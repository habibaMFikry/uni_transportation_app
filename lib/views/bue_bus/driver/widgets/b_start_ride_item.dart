import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BStartRideItem extends StatelessWidget {
  final dynamic passengerData;
  const BStartRideItem({super.key, required this.passengerData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Card(
        elevation: 15,
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.person),
            Expanded(
              child: ListTile(
                title: Text('Student Name: ${passengerData['first name']} '
                    '${passengerData['last name']}'),
                subtitle:
                    Text('Phone number: ${passengerData['phone number']}'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    launchUrl(Uri.parse('tel://${passengerData['phone number']}'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
