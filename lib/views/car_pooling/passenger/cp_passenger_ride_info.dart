import 'package:flutter/material.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/cp_ride.dart';

class CpPassengerRideInfo extends StatelessWidget {
  static const routeName = '/cp-passenger-ride-info';

  const CpPassengerRideInfo({super.key});

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

  @override
  Widget build(BuildContext context) {
    CpRide rideInfo = ModalRoute.of(context)!.settings.arguments as CpRide;
    return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Ride Information',style: TextStyle(color: Colors.black),
          ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
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
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                children: [
                 const SizedBox(height: 30),
                  const Icon(
                    Icons.info_outline,
                    size: 40,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 10),
                      Text('Starting: ${rideInfo.startLocation}'),
                    ],
                  ),
                  SizedBox(height: 2.h),
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
                      const SizedBox(width: 10),
                      Text('Ride time: ${rideInfo.rideTime}'),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(width: 10),
                      Text('Ride price: ${rideInfo.price}'),
                    ],
                  ),
                  SizedBox(height: 6.h),
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
      ),
    );
  }
}
