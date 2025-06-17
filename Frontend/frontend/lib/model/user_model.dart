class UserModel {
  final int id;
  final String username;
  final String email;
  final bool isStaff;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isStaff: json['is_staff'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'is_staff': isStaff,
    };
  }
}
