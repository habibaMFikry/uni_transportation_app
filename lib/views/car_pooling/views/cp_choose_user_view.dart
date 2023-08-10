import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';
import '../cubits/cp_ride_cubit/cp_ride_cubit.dart';
import '../driver/cp_driver_bottom_nav_bar.dart';
import '../driver/cp_driver_start_ride_view.dart';
import '../driver/car_info_form_view.dart';
import '../models/cp_ride.dart';
import '../models/cp_user.dart';
import '../passenger/cp_passenger_bottom_nav.dart';
import '../passenger/cp_passenger_start_ride.dart';

class CPChooseUserView extends StatefulWidget {
  static const routeName = '/cp-choose-user-view';
  const CPChooseUserView({super.key});

  @override
  State<CPChooseUserView> createState() => _CPChooseUserViewState();
}

class _CPChooseUserViewState extends State<CPChooseUserView> {
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

        final bool dHasRide = BlocProvider.of<CpRideCubit>(context).dHasRide;
        final bool pHasRide = BlocProvider.of<CpRideCubit>(context).pHasRide;

        final CpUser driverInfo =
            BlocProvider.of<CpRideCubit>(context).driverInfo;
        final CpRide passRide = BlocProvider.of<CpRideCubit>(context).passRide;

        return Scaffold(
          backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text('Hello, ${user.firstName}',style: const TextStyle(color: Colors.black),),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('items/car_logo2.png'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        if (pHasRide) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return CpPassengerStartRide(
                                    driverInfo: driverInfo, rideInfo: passRide);
                              },
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacementNamed(
                              CpPassengerBottomNav.routeName);
                        }
                      },
                      child: const Text(
                        'Passenger',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        if (dHasRide) {
                        
                          BlocProvider.of<CpGetUserInfoCubit>(context)
                              .getUserInfo();
                          BlocProvider.of<CpRideCubit>(context).getDriverRide();
                          Navigator.of(context).pushReplacementNamed(
                              CpDriverStartRide.routeName);
                        } else if (dHasRide == false) {
                          if (user.carType.isNotEmpty) {
                            Navigator.of(context).pushReplacementNamed(
                              CpDriverBottomNavBar.routeName,
                            );
                          } else {
                            Navigator.of(context).pushReplacementNamed(
                                CarInfoFormView.routeName,
                                arguments: user.carType);
                          }
                        }
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
