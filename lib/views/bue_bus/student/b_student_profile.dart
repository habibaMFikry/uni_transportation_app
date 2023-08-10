import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/b_get_student_info_cubit/b_get_student_info_cubit.dart';
import '../models/b_student.dart';
import 'b_student_edit_profile.dart';
import 'b_student_login.dart';

class BStudentProfile extends StatefulWidget {
  const BStudentProfile({super.key});

  @override
  State<BStudentProfile> createState() => _BStudentProfileState();
}

class _BStudentProfileState extends State<BStudentProfile> {
  @override
  void initState() {
    BlocProvider.of<BGetStudentInfoCubit>(context).getStudentInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BGetStudentInfoCubit, BGetStudentInfoState>(
      builder: (context, state) {
        final BStudent student =
            BlocProvider.of<BGetStudentInfoCubit>(context).studentData;
        if (state is BGetStudentInfoSuccess) {
          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Your Profile',style: TextStyle(color: Colors.black),
          ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(BStudentEditProfile.routeName);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            body: Align(alignment: Alignment.center,
              child: Card
              (elevation: 15,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Container(
                  height: MediaQuery.of(context).size.height*.55,
                        width: MediaQuery.of(context).size.width*.90,
                        decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                        ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.black54),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Name',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  '${student.firstName} ${student.lastName}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.black54),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  student.email,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.black54),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  student.phoneNumber,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 45),
                                backgroundColor: Colors.black
                              ),
                              child: const Text('Sign out'),
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context)
                                    .pushReplacementNamed(BStudentLogin.routeName);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        if (state is BGetStudentInfoFailure) {
          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Your Profile',style: TextStyle(color: Colors.black),
          ),
              ),
              body: Center(child: Text(state.errorMessage)));
        } else {
          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Your Profile',style: TextStyle(color: Colors.black),
          ),
              ),
              body: const Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
