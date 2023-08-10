import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../models/cp_locations.dart';
import '../cp_passenger_choose_time.dart';

class CpPassengerLocationItem extends StatelessWidget {
  const CpPassengerLocationItem({super.key, required this.location});

  final CpLocations location;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          CPPassengerChooseTime.routeName,
          arguments: CpLocations(
            startLocation: location.startLocation,
            price: location.price,
            destinationLocation: location.destinationLocation,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Card(
          elevation: 15,
          margin: EdgeInsets.symmetric(
            vertical: 0.75.h,
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.drive_eta),
              Expanded(
                child: ListTile(
                  title: Text(
                    '${location.startLocation}'
                    ' to ${location.destinationLocation}',
                  ),
                  subtitle: Text('Price ${location.price}'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
