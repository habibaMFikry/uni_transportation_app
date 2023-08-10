import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../cubits/cp_ride_cubit/cp_ride_cubit.dart';

class ChooseRideItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String text1;
  final String text2;
  final String text3;
  final String route;

  const ChooseRideItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: SizedBox(
          width: 75.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: SizedBox(
                    height: 14.h,
                    child: Image.asset(
                      imageUrl,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    const Icon(Icons.check),
                    const SizedBox(width: 10),
                    Text(text1),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    const Icon(Icons.check),
                    const SizedBox(width: 10),
                    Text(text2),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    const Icon(Icons.check),
                    const SizedBox(width: 10),
                    Text(text3),
                  ],
                ),
                SizedBox(height: 6.h),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CpRideCubit>(context).checkPassengerRide();
                    BlocProvider.of<CpRideCubit>(context).checkDriverRide();
                    Navigator.of(context).pushNamed(route);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
