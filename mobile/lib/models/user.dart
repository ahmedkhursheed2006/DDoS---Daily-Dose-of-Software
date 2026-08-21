class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final int streakDays;
  final int conceptsMastered;
  final double accuracy;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.streakDays,
    required this.conceptsMastered,
    required this.accuracy,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      streakDays: _parseInt(json['streakDays'] ?? json['streak_days']),
      conceptsMastered: _parseInt(
        json['conceptsMastered'] ?? json['concepts_mastered'],
      ),
      accuracy: _parseDouble(json['accuracy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'streakDays': streakDays,
      'conceptsMastered': conceptsMastered,
      'accuracy': accuracy,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
