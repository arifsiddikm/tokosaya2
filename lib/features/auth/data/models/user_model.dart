class UserModel {
  final int id;
  final String email;
  final String username;
  final String password;
  final String firstname;
  final String lastname;
  final String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstname: json['name']?['firstname'] ?? '',
      lastname: json['name']?['lastname'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  String get fullName => '$firstname $lastname'.trim();
}
