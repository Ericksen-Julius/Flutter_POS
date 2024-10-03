class User {
  int userId;
  String name;
  String password;
  String jabatan;

  User({
    required this.userId,
    required this.name,
    required this.password,
    required this.jabatan,
  });

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'USER_ID': userId,
      'NAMA': name,
      'PASSWORD': password,
      'JABATAN': jabatan,
    };
  }

  // Create User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['USER_ID'] is int
          ? json['USER_ID'] as int // Directly cast if it's an int
          : int.parse(json['USER_ID']), // Adjust case to match your JSON
      name: json['NAMA'] as String,
      password: json['PASSWORD'] as String,
      jabatan: json['JABATAN'] as String,
    );
  }
}
