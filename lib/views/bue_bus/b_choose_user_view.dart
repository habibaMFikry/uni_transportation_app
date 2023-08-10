import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'cubits/b_get_locations_cubit/b_get_locations_cubit.dart';
import 'cubits/b_ride_cubit/b_ride_cubit.dart';
import 'driver/b_driver_login.dart';
import 'student/b_student_login.dart';

class BChooseUserView extends StatefulWidget {
  static const routeName = '/b-choose-user-view';
  const BChooseUserView({super.key});

  @override
  State<BChooseUserView> createState() => _BChooseUserViewState();
}

class _BChooseUserViewState extends State<BChooseUserView> {
  @override
  void initState() {
    BlocProvider.of<BGetLocationsCubit>(context).bGetLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BRideCubit, BRideState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Hello',style: TextStyle(color: Colors.black),),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'items/bus.png',
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(BStudentLogin.routeName);
                      },
                      child: const Text(
                        'Student',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(BDriverLogin.routeName);
                      },
                      child: const Text(
                        'Driver',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
