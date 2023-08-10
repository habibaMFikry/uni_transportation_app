import 'package:firebase_auth/firebase_auth.dart';

class CpUser {
  String? userId;
  String firstName;
  String lastName;
  String email;
  String? password;
  String phoneNumber;
  String carType;
  int nofSeats;

  CpUser({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.phoneNumber,
    this.carType = '',
    this.nofSeats = 0,
  });

  toJson() {
    return {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': email,
      'first name': firstName,
      'last name': lastName,
      'phone number': phoneNumber,
    };
  }

  factory CpUser.fromJson(json) {
    return CpUser(
      userId: json['uid'],
      email: json['email'] ?? '',
      firstName: json['first name'] ?? '',
      lastName: json['last name'] ?? '',
      phoneNumber: json['phone number'] ?? '',
      carType: json['car type'] ?? '',
      nofSeats: json['number of seats'] ?? 0,
    );
  }
}
