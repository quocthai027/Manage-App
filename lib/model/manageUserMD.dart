class User {
  final int id;
  final String username;
  final String name;
  final String updatedAt;
  final String createdAt;
  final String role;
  late final int status;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    required this.role,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      role: json['role'],
      status: json['status'],
    );
  }
}

class UserListResponse {
  final String success;
  final List<User> users;
  final bool isLastPage;

  UserListResponse({
    required this.success,
    required this.users,
    required this.isLastPage,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      success: json['success'],
      users: (json['users'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson))
          .toList(),
      isLastPage: json['is_last_page'],
    );
  }
}
