class Users {
  final int userId;
  final String userName;
  final String password;
  final String email;

  const Users({
    required this.userId,
    required this.userName,
    required this.password,
    required this.email,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['userId'],
      userName: json['userName'],
      password: json['password'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'password': password,
      'email': email,
    };
  }

}