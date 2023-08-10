import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../car_pooling/views/cp_choose_user_view.dart';

class BVerificationView extends StatefulWidget {
  static const routeName = '/verification-view';
  const BVerificationView({Key? key}) : super(key: key);

  @override
  State<BVerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<BVerificationView> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    verify();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          const Center(
            child: Text(
              'Email verification',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(height: 100),
          Text("Verification email has been sent to ${user!.email}"),
          const SizedBox(height: 20),
          ElevatedButton.icon(
             style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                    ),
            icon: const Icon(Icons.email),
            label: const Text('Resend email'),
            onPressed: () {
              verify();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Verification email has been sent",
                  ),
                  duration: Duration(seconds: 2)
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  verify() {
    user = auth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      checkVerify();
    });
  }

  Future<void> checkVerify() async {
    user = auth.currentUser;
    await user!.reload();
    check();
  }

  check() {
    if (user!.emailVerified) {
      timer!.cancel();
      Navigator.of(context).pushReplacementNamed(CPChooseUserView.routeName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Account signed up successfully",
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
