import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';
import '../cubits/cp_ride_cubit/cp_ride_cubit.dart';
import '../models/cp_locations.dart';
import '../models/cp_ride.dart';
import '../widgets/custom_text_field.dart';
import 'cp_passenger_ride_list.dart';

class CPPassengerChooseTime extends StatefulWidget {
  static const routeName = 'cp-passenger-ChooseTimew';
  const CPPassengerChooseTime({super.key});

  @override
  State<CPPassengerChooseTime> createState() => _CPPassengerChooseTimeState();
}

class _CPPassengerChooseTimeState extends State<CPPassengerChooseTime> {
  TextEditingController timeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final CpLocations location =
        ModalRoute.of(context)!.settings.arguments as CpLocations;
    return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Pick Up Time',style: TextStyle(color: Colors.black),
          ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(  color: Color(0xffFFF9E1),
       ),
        alignment: Alignment.center,
        child: Card
        ( elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Form(
            key: formKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              width: 350,
              height: 400,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      title: 'Time',
                      keyboardType: TextInputType.datetime,
                      textController: timeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Location';
                        } else {
                          return null;
                        }
                      },
                    ),
                    ElevatedButton(
                    style: ElevatedButton.styleFrom(  backgroundColor: Colors.black
                          ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            BlocProvider.of<CpRideCubit>(context)
                                .getRidesAndDriverInfo(
                              start: location.startLocation,
                              des: location.destinationLocation,
                              time: timeController.text,
                            );
                            BlocProvider.of<CpGetUserInfoCubit>(context)
                                .getUserInfo();
                          });
                          Navigator.of(context).pushNamed(
                            CpPassengerRideList.routeName,
                            arguments: CpRide(
                              startLocation: location.startLocation,
                              rideTime: timeController.text,
                              destinationLocation: location.destinationLocation,
                            ),
                          );
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
