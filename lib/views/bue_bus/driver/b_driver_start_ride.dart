import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../cubits/b_ride_cubit/b_ride_cubit.dart';
import '../models/b_locations.dart';
import 'widgets/b_start_ride_item.dart';

class BDriverStartRide extends StatelessWidget {
  static const routeName = 'b-driver-start-ride';
  const BDriverStartRide({super.key});

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

  void sendNotification(
      {required String token,
      required String body,
      required String title}) async {
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
    final BLocations location =
        ModalRoute.of(context)!.settings.arguments as BLocations;
    DocumentReference rideRef = FirebaseFirestore.instance
        .collection('Bus_rides')
        .doc(location.busId.toString());

    return StreamBuilder(
        stream: rideRef.snapshots(),
        builder: (context, snapshot) {
          var rideDoc = snapshot.data;
          List<dynamic> studentsList = rideDoc?['students'] ?? [];
          List<dynamic> stopPiontsList = rideDoc?['stop points'] ?? [];
          List<dynamic> studentsOnBus = rideDoc?['students on bus'] ?? [];

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Students',style: TextStyle(color: Colors.black),
          ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Directions',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (rideDoc?['stop point 1'] == false) {
                                        mapsDirections(stopPiontsList[0]);
                                      } else if (rideDoc?['stop point 1'] ==
                                              true &&
                                          rideDoc?['stop point 2'] == false) {
                                        mapsDirections(stopPiontsList[1]);
                                      } else if (rideDoc?['stop point 2'] ==
                                              true &&
                                          rideDoc?['stop point 3'] == false) {
                                        mapsDirections(stopPiontsList[2]);
                                      } else if (rideDoc?['stop point 1'] ==
                                              true &&
                                          rideDoc?['stop point 2'] == true &&
                                          rideDoc?['stop point 3'] == true) {
                                        mapsDirections(
                                            rideDoc?['destination location']);
                                      }
                                    },
                                    child: const Text('Google maps'),
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
                      }),
                )
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Card(
                    color: Colors.grey[500],
                    child: Padding(
                      padding: EdgeInsets.all(1.h),
                      child: Row(
                        children: [
                          Text(
                            'Number of students on bus :  ',
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                          Text(
                            studentsOnBus.length.toString(),
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
                    itemCount: studentsList.length,
                    itemBuilder: (ctx, i) {
                      return BStartRideItem(
                        passengerData: studentsList[i],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (rideDoc?['stop point 1'] == true &&
                          rideDoc?['stop point 2'] == true &&
                          rideDoc?['stop point 3'] == true)
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'End Ride',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).popUntil(
                                (Route<dynamic> route) => route.isFirst);
                            BlocProvider.of<BRideCubit>(context)
                                .deleteRide(location.busId);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Your ride ended',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    rideDoc?['stop point 1'] == false
                                        ? Colors.black
                                        : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Stop point 1',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                for (String element
                                    in rideDoc?['students tokens']) {
                                  sendNotification(
                                      token: element,
                                      body: 'stop point 1',
                                      title: 'stop point 1');
                                }
                                rideDoc?['stop point 1'] == false
                                    ? FirebaseFirestore.instance
                                        .collection('Bus_rides')
                                        .doc(location.busId.toString())
                                        .update({
                                        'stop point 1': true,
                                      })
                                    : null;
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    rideDoc?['stop point 2'] == false
                                        ? Colors.black
                                        : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Stop point 2',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                for (String element
                                    in rideDoc?['students tokens']) {
                                  sendNotification(
                                      token: element,
                                      body: 'stop point 2',
                                      title: 'stop point 2');
                                }
                                rideDoc?['stop point 2'] == false
                                    ? FirebaseFirestore.instance
                                        .collection('Bus_rides')
                                        .doc(location.busId.toString())
                                        .update({
                                        'stop point 2': true,
                                      })
                                    : null;
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    rideDoc?['stop point 3'] == false
                                        ? Colors.black
                                        : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Stop point 3',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                for (String element
                                    in rideDoc?['students tokens']) {
                                  sendNotification(
                                      token: element,
                                      body: 'stop point 3',
                                      title: 'stop point 3');
                                }
                                rideDoc?['stop point 3'] == false
                                    ? FirebaseFirestore.instance
                                        .collection('Bus_rides')
                                        .doc(location.busId.toString())
                                        .update({
                                        'stop point 3': true,
                                      })
                                    : null;
                              },
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        });
  }
}
