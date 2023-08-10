import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../driver/services/b_notification_service.dart';
import '../models/b_driver.dart';
import '../models/b_ride.dart';
import 'b_student_ride_info.dart';

class BStudentStartRide extends StatefulWidget {
  final BDriver driver;
  final BRide ride;
  const BStudentStartRide(
      {super.key, required this.driver, required this.ride});

  @override
  State<BStudentStartRide> createState() => _BStudentStartRideState();
}

class _BStudentStartRideState extends State<BStudentStartRide> {
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
        .collection('Bus_rides')
        .doc(widget.driver.busId.toString())
        .update({
      'students tokens': FieldValue.arrayUnion([
        token,
      ])
    });
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
                BStudentRideInfo.routeName,
                arguments: BRide(
                  startLocation: widget.ride.startLocation,
                  stopPoints: widget.ride.stopPoints,
                  destinationLocation: widget.ride.destinationLocation,
                  nOfSeatsAvailable: widget.ride.nOfSeatsAvailable,
                  busID: widget.ride.busID,
                  time: widget.ride.time,
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Card(
              elevation: 15,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.person),
                  Expanded(
                    child: ListTile(
                      title: Text(
                          'Driver\'s name: ${widget.driver.name}'),
                      subtitle:
                          Text('Phone number: ${widget.driver.phoneNumber}'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          launchUrl(Uri.parse('tel://${widget.driver.phoneNumber}'));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                    ),
                onPressed: () {
                  String sID = FirebaseAuth.instance.currentUser!.uid;
                  FirebaseFirestore.instance
                      .collection('Bus_rides')
                      .doc(widget.driver.busId.toString())
                      .update({
                    'students on bus': FieldValue.arrayUnion([
                      {
                        'id': sID,
                      },
                    ]),
                  });
                },
                child: const Text('On Bus'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}