// lib/services/auth_service.dart
// SDD: lib/services/ — owns the full authentication flow:
//   login / register API calls  +  secure token/user persistence.
//
// Circular-dependency note:
//   DioClient imports AuthService (to read the JWT for the Bearer interceptor).
//   AuthService therefore uses a private Dio instance for its own HTTP calls
//   rather than importing DioClient. Login and register are pre-authentication
//   requests that do not require the JWT interceptor, so this is correct.

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _userKey = 'user_data';

  // ── Private Dio for unauthenticated auth requests ─────────────────────────
  // A minimal Dio instance used only for /auth/login and /auth/register.
  // These endpoints do not require a JWT, so DioClient's Bearer interceptor
  // is not needed and must not be used here (circular dependency).
  static final _authDio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // ── Authentication API ─────────────────────────────────────────────────────

  /// Authenticates the user via POST /auth/login.
  /// On success: saves JWT token and User to secure storage.
  /// On failure: rethrows the DioException for the caller to handle.
  static Future<void> login(String email, String password) async {
    final response = await _authDio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    await _persistAuthResponse(response);
    debugPrint('[AuthService] Login successful.');
  }

  /// Registers a new user via POST /auth/register.
  /// On success: saves JWT token and User to secure storage.
  /// On failure: rethrows the DioException for the caller to handle.
  static Future<void> register(
      String name, String email, String password) async {
    final response = await _authDio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
    await _persistAuthResponse(response);
    debugPrint('[AuthService] Registration successful.');
  }

  /// Shared helper: extracts token + user from the API response and persists both.
  static Future<void> _persistAuthResponse(
      Response<Map<String, dynamic>> response) async {
    final payload = response.data?['data'];
    if (payload == null) throw Exception('Unexpected server response.');

    final token = payload['token']?.toString();
    if (token == null || token.isEmpty) throw Exception('No token received.');

    await saveToken(token);
    if (payload['user'] != null) {
      await saveUser(User.fromJson(payload['user'] as Map<String, dynamic>));
    }
  }

  // ── JWT Token ─────────────────────────────────────────────────────────────

  /// Saves the JWT token securely.
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      debugPrint('[AuthService] Token saved successfully.');
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error saving token: $e\n$stackTrace');
    }
  }

  /// Returns the saved JWT token, or null if not found.
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

  /// Deletes the JWT token only. Prefer [logout] for full sign-out.
  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      debugPrint('[AuthService] Token deleted successfully.');
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error deleting token: $e\n$stackTrace');
    }
  }

  /// Returns true if a non-empty JWT token is stored.
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

  /// Decodes the JWT payload to extract userId.
  static Future<String?> getUserId() async {
    try {
      final token = await getToken();
      if (token == null || token.trim().isEmpty) {
        debugPrint('[AuthService] No token found to extract userId.');
        return null;
      }

      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint('[AuthService] Invalid JWT structure (parts: ${parts.length}).');
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
      debugPrint('[AuthService] Error decoding JWT: $e\n$stackTrace');
      return null;
    }
  }

  // ── User Data ─────────────────────────────────────────────────────────────

  /// Persists the User object to secure storage as JSON.
  static Future<void> saveUser(User user) async {
    try {
      await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
      debugPrint('[AuthService] User saved: ${user.email}');
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error saving user: $e\n$stackTrace');
    }
  }

  /// Returns the persisted User, or null if not found / parse fails.
  static Future<User?> getUser() async {
    try {
      final data = await _storage.read(key: _userKey);
      if (data == null) return null;
      return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error reading user: $e\n$stackTrace');
      return null;
    }
  }

  /// Removes the persisted user from secure storage.
  static Future<void> clearUser() async {
    try {
      await _storage.delete(key: _userKey);
      debugPrint('[AuthService] User data cleared.');
    } catch (e, stackTrace) {
      debugPrint('[AuthService] Error clearing user: $e\n$stackTrace');
    }
  }

  // ── Full Sign-Out ─────────────────────────────────────────────────────────

  /// Clears both JWT token and persisted user data. Use for logout and 401.
  static Future<void> logout() async {
    await deleteToken();
    await clearUser();
    debugPrint('[AuthService] Full logout complete — token and user data cleared.');
  }
}
