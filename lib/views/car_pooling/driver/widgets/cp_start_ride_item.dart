import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';

class CpStartRideItem extends StatelessWidget {
  final dynamic passengerData;
  const CpStartRideItem({super.key, required this.passengerData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CpGetUserInfoCubit, CpGetUserInfoState>(
      builder: (context, state) {
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
                    title: Text('${passengerData['first name']} '
                        '${passengerData['last name']}'),
                    subtitle:
                        Text('Phone Number: ${passengerData['phone number']}'),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // launch('tel://${passengerData['phone number']}');
                        launchUrl(Uri.parse('tel://${passengerData['phone number']}'));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
