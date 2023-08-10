import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/b_ride.dart';

class BStudentRideInfo extends StatelessWidget {
  static const routeName = '/cp-student-ride-info';
  const BStudentRideInfo({super.key});

  final String mapApiKey = 'AIzaSyDZjAlxAZNL5-MqDdXPz2L7UNEDmTTS6Ws';

  void mapsDirections(String place) async {
    final LocatitonGeocoder geocoder = LocatitonGeocoder(mapApiKey);
    final address = await geocoder.findAddressesFromQuery(place);

    var lat = address.first.coordinates.latitude;
    var long = address.first.coordinates.longitude;
    String mapUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunchUrl(Uri.parse (mapUrl))) {
      await launchUrl(Uri.parse (mapUrl));
    } else {
      throw 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    BRide rideInfo = ModalRoute.of(context)!.settings.arguments as BRide;

    DocumentReference rideRef = FirebaseFirestore.instance
        .collection('Bus_rides')
        .doc(rideInfo.busID.toString());

    return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Ride Information',style: TextStyle(color: Colors.black),
          ),
      ),
      body: StreamBuilder(
          stream: rideRef.snapshots(),
          builder: (context, snapshot) {
            var rideDoc = snapshot.data;

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (rideDoc?.data() == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return AlertDialog(
                        title: const Text('Your ride ended'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).popUntil(
                                  (Route<dynamic> route) => route.isFirst);
                            },
                            child: const Text('Back'),
                          ),
                        ],
                      );
                    });
              });
            }
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Card(
                elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Container(
                  height: MediaQuery.of(context).size.height * .55,
                  width: MediaQuery.of(context).size.height * .45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        const Icon(
                          Icons.info_outline,
                          size: 35,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 10),
                            Text('Starting: ${rideInfo.startLocation}'),
                          ],
                        ),
                      
                        SizedBox(height: 2.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.location_on),
                                SizedBox(width: 10),
                                Text(
                                  'Stop Points',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Icon(rideDoc?['stop point 1'] == false
                                    ? Icons.timer_outlined
                                    : Icons.done),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text('${rideInfo.stopPoints[0]}'),
                                ),
                                const SizedBox(width: 5),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    mapsDirections(rideInfo.stopPoints[0]);
                                  },
                                  child: const Text('Location'),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(rideDoc?['stop point 2'] == false
                                    ? Icons.timer_outlined
                                    : Icons.done),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text('${rideInfo.stopPoints[1]}')),
                                const SizedBox(width: 5),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    mapsDirections(rideInfo.stopPoints[1]);
                                  },
                                  child: const Text('Location'),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(rideDoc?['stop point 3'] == false
                                    ? Icons.timer_outlined
                                    : Icons.done),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text('${rideInfo.stopPoints[2]}')),
                                const SizedBox(width: 5),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    mapsDirections(rideInfo.stopPoints[2]);
                                  },
                                  child: const Text('Location'),
                                )
                              ],
                            ),
                          ],
                        ),  SizedBox(height: 1.h),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 10),
                            Text('Destination: ${rideInfo.destinationLocation}'),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined),
                            const SizedBox(width:10),
                             Text('Starting: ${rideInfo.time}'),
                          ],
                        ),
                        SizedBox(height:3.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                      ),
                          onPressed: () {
                            mapsDirections(rideInfo.startLocation);
                          },
                          child: const Text('Start Location on maps'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}