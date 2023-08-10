import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../bue_bus/driver/services/b_notification_service.dart';
import '../models/cp_ride.dart';
import '../models/cp_user.dart';
import 'cp_passenger_ride_info.dart';

class CpPassengerStartRide extends StatefulWidget {
  static const routeName = 'cp-passenger-start-ride';

  final CpUser driverInfo;
  final CpRide rideInfo;
  const CpPassengerStartRide({
    super.key,
    required this.driverInfo,
    required this.rideInfo,
  });

  @override
  State<CpPassengerStartRide> createState() => _CpPassengerStartRideState();
}

class _CpPassengerStartRideState extends State<CpPassengerStartRide> {
  String? passengerToken = '';

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
     await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        setState(() {
          passengerToken = token;
        });
        saveToken(token);
      },
    );
  }

  void saveToken(String? token) async {
    await FirebaseFirestore.instance
        .collection('Carpooling rides')
        .doc(widget.driverInfo.userId)
        .update({
      'passengers tokens': FieldValue.arrayUnion([
        token,
      ])
    });
  }

  bool checkPassenger(List<dynamic>? listOfPass) {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    late bool pHasRide;
    if (listOfPass != [] && listOfPass != null) {
      for (var element in listOfPass) {
        if (currentUser == element['uid']) {
          pHasRide = true;
          return pHasRide;
        }
      }
    } else {
      pHasRide = false;
    }
    return pHasRide;
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference rideRef = FirebaseFirestore.instance
        .collection('Carpooling rides')
        .doc(widget.driverInfo.userId);

    return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Driver Information',style: TextStyle(color: Colors.black),
          ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                CpPassengerRideInfo.routeName,
                arguments: CpRide(
                  startLocation: widget.rideInfo.startLocation,
                  rideTime: widget.rideInfo.rideTime,
                  destinationLocation: widget.rideInfo.destinationLocation,
                  nOfSeatsAvailable: widget.rideInfo.nOfSeatsAvailable,
                  price: widget.rideInfo.price,
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: StreamBuilder(
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
                          title: const Text('The ride has ended'),
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
              return rideDoc?.data() != null &&
                      checkPassenger(rideDoc?['passengers'])
                  ? SizedBox(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 15,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(Icons.person),
                              Expanded(
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                        'Driver\'s name: ${widget.driverInfo.firstName}'
                                        ' ${widget.driverInfo.lastName}'),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Car type: ${widget.driverInfo.carType}'),
                                      Text(
                                          'Phone number: ${widget.driverInfo.phoneNumber}'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          'tel://${widget.driverInfo.phoneNumber}'));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Center();
            }),
      ),
    );
  }
}
