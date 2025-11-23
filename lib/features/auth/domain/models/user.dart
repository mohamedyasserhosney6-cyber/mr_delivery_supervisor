class User {
  final int id;
  final String name;
  final String? phone;
  final String role;
  final String? token;

  User({
    required this.id,
    required this.name,
    this.phone,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'supervisor',
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'token': token,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? phone,
    String? role,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }
}

