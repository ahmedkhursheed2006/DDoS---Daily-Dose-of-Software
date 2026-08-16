// lib/models/user.dart
// SDD: lib/models/ — data/domain models
// Maps T5 login response: { token, user: { id, name, email, role } }  (root level, no wrapper)

class User {
  final String id;
  final String name;
  final String email;
  final String? role;
  final int streakDays;
  final int conceptsMastered;
  final double accuracy;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.streakDays = 0,
    this.conceptsMastered = 0,
    this.accuracy = 0.0,
  });

  /// Deserialise from the backend JSON response.
  /// Handles both `id` and `_id` (Mongo style), and defensive null fallbacks.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString(),
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      conceptsMastered: (json['conceptsMastered'] as num?)?.toInt() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Serialise to JSON for secure storage persistence.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'streakDays': streakDays,
        'conceptsMastered': conceptsMastered,
        'accuracy': accuracy,
      };
}
