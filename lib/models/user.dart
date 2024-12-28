class User {
  final String username;
  final String password; // Dalam praktik nyata, password harus di-hash
  final String role; // misalnya: 'admin', 'staff'

  User({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      role: map['role'],
    );
  }
}