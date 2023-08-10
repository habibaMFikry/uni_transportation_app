import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../cubits/b_get_driver_cubit/b_get_driver_cubit.dart';
import '../cubits/b_get_locations_cubit/b_get_locations_cubit.dart';
import '../cubits/b_ride_cubit/b_ride_cubit.dart';
import '../models/b_driver.dart';
import '../models/b_locations.dart';
import 'b_driver_bottom_nav.dart';
import 'b_driver_start_ride.dart';
import 'widgets/b_driver_text_fields.dart';

class BDriverLogin extends StatefulWidget {
  static const routeName = 'b-driver-login';
  const BDriverLogin({super.key});

  @override
  State<BDriverLogin> createState() => _BDriverLoginState();
}

class _BDriverLoginState extends State<BDriverLogin> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  final TextEditingController busIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Hello!',style: TextStyle(color: Colors.black),),
          ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BDriverTextFields(
                emailController: busIDController,
                passwordController: passwordController,
              ),
              SizedBox(height: 5.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                    ),
                  onPressed: () async {
                    if (loginKey.currentState!.validate()) {
                      var locationCubit =
                          BlocProvider.of<BGetLocationsCubit>(context);
                      var infoCubit = BlocProvider.of<BGetDriverCubit>(context);
                      var rideCubit = BlocProvider.of<BRideCubit>(context);
                      var nav = Navigator.of(context);
                      List<BDriver> driversList = await BlocProvider.of<BGetDriverCubit>(context) .bGetDriversList();
                      List<BDriver> driversListCopy = List.from(driversList);

                      for (var element in driversListCopy) {
                        if (element.busId == int.parse(busIDController.text) &&
                            element.password == int.parse(passwordController.text)) {
                          locationCubit.bGetDriverLocations(int.parse(busIDController.text));
                          infoCubit.bGetDriverInfo(busID: int.parse(busIDController.text));
                          var hasRide = await rideCubit.checkBDriverRide(int.parse(busIDController.text));

                          if (hasRide) {
                            var ride = await rideCubit.getRide(int.parse(busIDController.text));
                            nav.pushNamed(
                              BDriverStartRide.routeName,
                              arguments: BLocations(
                                busId: ride.busID,
                                startLocation: ride.startLocation,
                                stopPoints: ride.stopPoints,
                                destinationLocation: ride.destinationLocation,
                                availableSeats: ride.nOfSeatsAvailable,
                                time: ride.time,
                              ),
                            );
                          } else {
                            nav.pushReplacementNamed(BDriverBottomNav.routeName);
                          }
                        }
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
