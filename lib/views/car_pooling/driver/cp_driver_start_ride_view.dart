import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';
import '../cubits/cp_ride_cubit/cp_ride_cubit.dart';
import '../models/cp_ride.dart';
import '../models/cp_user.dart';
import 'cp_driver_ride_info.dart';
import 'widgets/cp_start_ride_item.dart';

class CpDriverStartRide extends StatefulWidget {
  static const routeName = 'Cp-driver-start-ride';
  const CpDriverStartRide({super.key});

  @override
  State<CpDriverStartRide> createState() => _CpDriverStartRideState();
}

class _CpDriverStartRideState extends State<CpDriverStartRide> {
  final String mapApiKey = 'AIzaSyDZjAlxAZNL5-MqDdXPz2L7UNEDmTTS6Ws';

  void mapsDirections(String place) async {
    final LocatitonGeocoder geocoder = LocatitonGeocoder(mapApiKey);
    final address = await geocoder.findAddressesFromQuery(place);

    var lat = address.first.coordinates.latitude;
    var long = address.first.coordinates.longitude;
    String mapUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl));
    } else {
      throw 'error';
    }
  }

  void sendNotification(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA2cd2Dfg:APA91bEO6oIRSe9W_oomMAdXQfYNn7eyoFNfKClYikLFWBx14ozkT7I0WAFc-un5P8YiLkrpPEaLNSThC1w5xc6sYtbBuDOyZnQngfkXDWy3AOehGiVOz0NifAnhOhqMfWdvR_dDh2I3'
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
            "android_channel_id": 'id',
          },
          "to": token,
        }),
      );
    } catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CpRideCubit, CpRideState>(
      builder: (context, state) {
        CpUser driverInfo =
            BlocProvider.of<CpGetUserInfoCubit>(context).userData;
        CpRide rideInfo = BlocProvider.of<CpRideCubit>(context).driverRide;

        DocumentReference rideRef = FirebaseFirestore.instance
            .collection('Carpooling rides')
            .doc(driverInfo.userId);

        return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Passengers Information',style: TextStyle(color: Colors.black),
          ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CpDriverRideInfo.routeName,
                    arguments: CpRide(
                      startLocation: rideInfo.startLocation,
                      rideTime: rideInfo.rideTime,
                      destinationLocation: rideInfo.destinationLocation,
                      nOfSeatsAvailable: rideInfo.nOfSeatsAvailable,
                      price: rideInfo.price,
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: StreamBuilder(
              stream: rideRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var rideDoc = snapshot.data;
                List<dynamic> passengersList = rideDoc?['passengers'] ?? [];

                
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Card(
                        color: Colors.grey[500],
                        child: Padding(
                          padding: EdgeInsets.all(1.h),
                          child: Row(
                            children: [
                              Text(
                                'Total price:  ',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.white),
                              ),
                              Text(
                                '${rideInfo.price.toString()}'
                                ' / ${passengersList.length + 1} = '
                                '${(rideInfo.price! / (passengersList.length + 1)).round()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const Divider(
                      height: 0,
                      color: Colors.black,
                      thickness: 1.5,
                      indent: 15,
                      endIndent: 15,
                    ),
                    SizedBox(height: 1.h),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: passengersList.length,
                        itemBuilder: (ctx, i) {
                          return CpStartRideItem(
                            passengerData: passengersList[i],
                          );
                        },
                      ),
                    ),
                    rideDoc?['ride started'] ?? false
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              List<dynamic>? tokenList =
                                  rideDoc?['passengers tokens'];

                              if (tokenList != null) {
                                for (var element in tokenList) {
                                  String passToken = element;

                                  sendNotification(
                                      passToken, 'The Ride has Ended', 'The Ride has Ended');
                                }
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('The Ride has Ended'),
                                      content: Row(
                                        children: [
                                          Text(
                                            'Total price:  ',
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          Text(
                                            '${rideInfo.price.toString()}'
                                            ' / ${passengersList.length + 1} = '
                                            '${(rideInfo.price! / (passengersList.length + 1)).round()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                           style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black
                                            ),
                                          onPressed: () {
                                            Navigator.of(context).popUntil(
                                                (Route<dynamic> route) =>
                                                    route.isFirst);
                                            BlocProvider.of<CpRideCubit>(
                                                    context)
                                                .deleteRide();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'the Ride has Ended',
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          child: const Text('Done'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('End ride'),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  List<dynamic>? tokenList =
                                      rideDoc?['passengers tokens'];

                                  if (tokenList != null) {
                                    for (var element in tokenList) {
                                      String passToken = element;

                                      sendNotification(
                                          passToken,
                                          'The Ride was canceled',
                                          'The Ride was canceled');
                                    }
                                  }
                                  Navigator.of(context).popUntil(
                                      (Route<dynamic> route) => route.isFirst);
                                  BlocProvider.of<CpRideCubit>(context)
                                      .deleteRide();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'The ride was canceled',
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cancel Ride',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (rideDoc?['passengers tokens'] == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'No passengers yet',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    List<dynamic>? tokenList =
                                        rideDoc?['passengers tokens'];

                                    if (tokenList != null) {
                                      for (var element in tokenList) {
                                        String passToken = element;

                                        sendNotification(passToken,
                                            'The Ride started', 'The Ride started');
                                      }

                                      FirebaseFirestore.instance
                                          .collection('Carpooling rides')
                                          .doc(driverInfo.userId)
                                          .update({'ride started': true});
                                      showDialog(
                                          context: context,
                                          builder: (builder) {
                                            return AlertDialog(
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    mapsDirections(rideInfo
                                                        .destinationLocation);
                                                  },
                                                  child:
                                                      const Text('Google maps'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('In app'),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  }
                                },
                                child: const Text(
                                  'Start Ride',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
