import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cp_user.dart';
import '../views/cp_login_view.dart';
import '../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';
import 'cp_passenger_edit_profile.dart';

class CpPassengerProfile extends StatefulWidget {
  static const routeName = '/cp-passenger-profile';
  const CpPassengerProfile({super.key});

  @override
  State<CpPassengerProfile> createState() => _CpPassengerProfileState();
}

class _CpPassengerProfileState extends State<CpPassengerProfile> {
  @override
  void initState() {
    BlocProvider.of<CpGetUserInfoCubit>(context).getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CpGetUserInfoCubit, CpGetUserInfoState>(
      builder: (context, state) {
        final CpUser user =
            BlocProvider.of<CpGetUserInfoCubit>(context).userData;
        if (state is CpGetUserInfoSuccess) {
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
                        .pushNamed(CpPassengerEditProfile.routeName);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            body: Align(alignment: Alignment.center,
              child: Card(elevation: 15,
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
                                  '${user.firstName} ${user.lastName}',
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
                                  user.email,
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
                                  user.phoneNumber,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 45),
                            backgroundColor: Colors.black
                          ),
                          child: const Text('Sign out'),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context)
                                .pushReplacementNamed(CPLoginView.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        if (state is CpGetUserInfoFailure) {
          return Scaffold(
            appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Your Profile',style: TextStyle(color: Colors.black),
          ),
            ),
            body: Center(child: Text(state.errorMessage)),
          );
        } else {
          return Scaffold(
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
