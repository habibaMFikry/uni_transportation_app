import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/b_get_driver_cubit/b_get_driver_cubit.dart';
import '../models/b_driver.dart';
import 'b_driver_login.dart';

class BDriverProfile extends StatelessWidget {
  static const routeName = 'b-driver-profile';
  const BDriverProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BGetDriverCubit, BGetDriverState>(
      builder: (context, state) {
        final BDriver driver = BlocProvider.of<BGetDriverCubit>(context).driver;
        if (state is BGetDriverSuccess) {
          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Your Profile',style: TextStyle(color: Colors.black),
          ),
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
                                  driver.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            const Icon(Icons.airport_shuttle, color: Colors.black54),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bus ID',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  driver.busId.toString(),
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
                                  driver.phoneNumber,
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
                                 backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 45),
                              ),
                              child: const Text('Sign out'),
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context)
                                    .pushReplacementNamed(BDriverLogin.routeName);
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
        if (state is BGetDriverFailure) {
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
