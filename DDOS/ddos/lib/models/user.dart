// lib/models/user.dart
// SDD: lib/models/ — data/domain models
// Maps T5 login response: { token, user: { id, name, email, role } } (root level, no wrapper)

class User {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? avatarPath;
  final int streakDays;
  final int conceptsMastered;
  final double accuracy;
  final String? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.avatarPath,
    this.streakDays = 0,
    this.conceptsMastered = 0,
    this.accuracy = 0.0,
    this.createdAt,
  });

  /// Deserialise from the backend JSON response.
  /// Handles both `id` and `_id` (Mongo style), and defensive null fallbacks.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString(),
      avatarPath: json['avatarPath']?.toString() ?? json['avatarUrl']?.toString(),
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      conceptsMastered: (json['conceptsMastered'] as num?)?.toInt() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt']?.toString(),
    );
  }

  /// Serialise to JSON for secure storage persistence.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'avatarPath': avatarPath,
        'streakDays': streakDays,
        'conceptsMastered': conceptsMastered,
        'accuracy': accuracy,
        'createdAt': createdAt,
      };

  /// Create a copy of User with updated fields.
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarPath,
    int? streakDays,
    int? conceptsMastered,
    double? accuracy,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarPath: avatarPath ?? this.avatarPath,
      streakDays: streakDays ?? this.streakDays,
      conceptsMastered: conceptsMastered ?? this.conceptsMastered,
      accuracy: accuracy ?? this.accuracy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

