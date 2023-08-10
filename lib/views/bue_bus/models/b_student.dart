import 'package:firebase_auth/firebase_auth.dart';

class BStudent {
  String? userId;
  String firstName;
  String lastName;
  String email;
  String? password;
  String phoneNumber;

  BStudent({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.phoneNumber,
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

  factory BStudent.fromJson(json) {
    return BStudent(
      userId: json['uid'],
      email: json['email'] ?? '',
      firstName: json['first name'] ?? '',
      lastName: json['last name'] ?? '',
      phoneNumber: json['phone number'] ?? '',
    );
  }
}
