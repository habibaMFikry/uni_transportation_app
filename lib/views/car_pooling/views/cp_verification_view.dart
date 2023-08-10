import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cp_choose_user_view.dart';

class CpVerificationView extends StatefulWidget {
  static const routeName = '/verification-view';
  const CpVerificationView({Key? key}) : super(key: key);

  @override
  State<CpVerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<CpVerificationView> {
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
          backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Email verification',style: TextStyle(color: Colors.black),),
          ),
      body: Align(
        child: Card(
          elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
           height: MediaQuery.of(context).size.height*.55,
            width: MediaQuery.of(context).size.width*.70,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const SizedBox(height: 70),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text("Verification email has been sent to ${user!.email}"),
                ),
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
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
