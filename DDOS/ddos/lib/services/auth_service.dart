import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  /// 1. Saves the JWT token with key 'jwt_token'
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      debugPrint('[AuthService] Token saved successfully.');
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error saving token: $e\n$stackTrace');
    }
  }

  /// 2. Returns `Future<String?>` containing the saved JWT token
  static Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      debugPrint('[AuthService] Token read: ${token != null ? 'Found' : 'Not found'}');
      return token;
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error reading token: $e\n$stackTrace');
      return null;
    }
  }

  /// 3. Deletes the token with key 'jwt_token'
  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      debugPrint('[AuthService] Token deleted successfully.');
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error deleting token: $e\n$stackTrace');
    }
  }

  /// 4. Returns `Future<bool>` (true if token exists)
  static Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      final loggedIn = token != null && token.trim().isNotEmpty;
      debugPrint('[AuthService] isLoggedIn: $loggedIn');
      return loggedIn;
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error checking login status: $e\n$stackTrace');
      return false;
    }
  }

  /// 5. Decodes JWT payload (split on '.') to extract userId
  static Future<String?> getUserId() async {
    try {
      final token = await getToken();
      if (token == null || token.trim().isEmpty) {
        debugPrint('[AuthService] No token found to extract userId.');
        return null;
      }

      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint('[AuthService] Invalid JWT token structure (parts count: ${parts.length}).');
        return null;
      }

      final normalizedPayload = base64.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalizedPayload));
      final Map<String, dynamic> payloadMap = jsonDecode(payloadString);

      final userId = payloadMap['userId']?.toString() ??
          payloadMap['id']?.toString() ??
          payloadMap['sub']?.toString();

      debugPrint('[AuthService] Extracted userId: $userId');
      return userId;
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error decoding JWT payload or extracting userId: $e\n$stackTrace');
      return null;
    }
  }
}
