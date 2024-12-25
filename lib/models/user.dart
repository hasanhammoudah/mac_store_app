import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String state;
  final String city;
  final String locality;
  final String email;
  final String password;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.state,
    required this.city,
    required this.locality,
    required this.email,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'state': state,
      'city': city,
      'locality': locality,
      'email': email,
      'password': password,
      'token': token,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      email: map['email'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'fullName': fullName,
  //       'state': state,
  //       'city': city,
  //       'locality': locality,
  //       'email': email,
  //       'password': password,
  //     };
}
