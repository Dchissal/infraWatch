class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final UserRole role;
  final DateTime lastLogin;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.role,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    avatar: json['avatar'],
    role: UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.viewer,
    ),
    lastLogin: DateTime.parse(json['lastLogin']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'avatar': avatar,
    'role': role.name,
    'lastLogin': lastLogin.toIso8601String(),
  };
}

enum UserRole { admin, technician, viewer }

class AuthToken {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthToken({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
    token: json['token'],
    refreshToken: json['refreshToken'],
    expiresAt: DateTime.parse(json['expiresAt']),
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'refreshToken': refreshToken,
    'expiresAt': expiresAt.toIso8601String(),
  };

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}