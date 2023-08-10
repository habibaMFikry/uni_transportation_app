import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../cubits/b_get_student_info_cubit/b_get_student_info_cubit.dart';
import '../../cubits/b_ride_cubit/b_ride_cubit.dart';
import '../../models/b_locations.dart';
import '../b_student_map.dart';

class BStudentLocationItem extends StatelessWidget {
  const BStudentLocationItem({super.key, required this.location});

  final BLocations location;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BRideCubit>(context).getRideAndDriverInfo(
            start: location.startLocation, des: location.destinationLocation);
        BlocProvider.of<BGetStudentInfoCubit>(context).getStudentInfo();
        Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
          return BStudentMap(location: location);
        }));
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
              const Icon(Icons.airport_shuttle),
              Expanded(
                child: ListTile(
                  title: Text(
                    '${location.startLocation}'
                    ' to ${location.destinationLocation}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3),
                      const Text(
                        'Stop Points',
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text(location.stopPoints[0]),
                      Text(location.stopPoints[1]),
                      Text(location.stopPoints[2]),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 12),
                      Text(location.time),
                    ],
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
