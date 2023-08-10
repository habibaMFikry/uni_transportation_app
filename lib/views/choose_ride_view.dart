import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'bue_bus/b_choose_user_view.dart';
import 'car_pooling/views/cp_choose_user_view.dart';
import 'car_pooling/views/cp_register_view.dart';
import 'car_pooling/cubits/cp_get_locations_cubit/cp_get_locations_cubit.dart';
import 'car_pooling/widgets/choose_ride_item.dart';

class ChooseRideView extends StatefulWidget {
  static const routeName = '/choose-ride-view';
  const ChooseRideView({super.key});

  @override
  State<ChooseRideView> createState() => _ChooseRideViewState();
}

class _ChooseRideViewState extends State<ChooseRideView> {
  @override
  void initState() {
    BlocProvider.of<CpGetLocationsCubit>(context).getLocations();
    super.initState();
  }

  String checkCPUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      return CPChooseUserView.routeName;
    } else {
      return CPRegisterview.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(  color: Color(0xffFFF9E1),
       ),
        child: Column(
          children: [
            SizedBox(height: 9.h),
            Text(
              'Choose your ride',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23.sp,fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 7.h),
            SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: ListView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                children: [
                  ChooseRideItem(
                      imageUrl: 'items/car_logo.jpg',
                      title: 'Car Pooling',
                      text1: 'Fast',
                      text2: 'Cost efficient',
                      text3: 'Travel with friends',
                      route: checkCPUser()),
                  const ChooseRideItem(
                      imageUrl: 'items/bus_logo.jpg',
                      title: 'Bus Routing',
                      text1: 'Safe',
                      text2: 'Scheduled',
                      text3: 'Choose your bus',
                      route: BChooseUserView.routeName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
