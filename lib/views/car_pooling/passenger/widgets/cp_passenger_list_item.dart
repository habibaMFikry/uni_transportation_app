import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../models/cp_ride.dart';
import '../../models/cp_user.dart';
import '../cp_passenger_start_ride.dart';

class CpPassengerListItem extends StatelessWidget {
  final CpUser driverInfo;
  final CpRide rideInfo;
  final CpUser passengerInfo;

  const CpPassengerListItem({
    super.key,
    required this.rideInfo,
    required this.driverInfo,
    required this.passengerInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseFirestore.instance
            .collection('Carpooling rides')
            .doc(driverInfo.userId)
            .update({
          'passengers': FieldValue.arrayUnion([
            {
              'uid': passengerInfo.userId,
              'first name': passengerInfo.firstName,
              'last name': passengerInfo.lastName,
              'email': passengerInfo.email,
              'phone number': passengerInfo.phoneNumber,
            }
          ]),
          'number of seats available': rideInfo.nOfSeatsAvailable! - 1,
        });

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return CpPassengerStartRide(
              driverInfo: driverInfo, rideInfo: rideInfo);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Card(
          elevation: 15,
          margin: EdgeInsets.symmetric(
            vertical: 0.75.h,
          ),
          child: ListTile(
            leading: const Icon(Icons.add_road_outlined),
            title: Text('${driverInfo.firstName}' ' ${driverInfo.lastName}'),
            subtitle: Text('Car type: ${driverInfo.carType}'
                '    Seats: ${rideInfo.nOfSeatsAvailable}'
                '    Time: ${rideInfo.rideTime}'),
            trailing: Text('\$${rideInfo.price.toString()}'),
          ),
        ),
      ),
    );
  }
}
