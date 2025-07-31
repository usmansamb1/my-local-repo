class User {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String? email;

  User({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}