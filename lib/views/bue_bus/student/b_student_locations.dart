import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/b_get_locations_cubit/b_get_locations_cubit.dart';
import '../models/b_locations.dart';
import 'widgets/b_student_location_item.dart';

class BStudentLocations extends StatelessWidget {
  static const routeName = 'b-student-locations';
  const BStudentLocations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BGetLocationsCubit, BGetLocationsState>(
      builder: (context, state) {
        List<BLocations> locationsList =
            BlocProvider.of<BGetLocationsCubit>(context).locationList;

        if (state is BGetLocationsSuccess) {
          return Scaffold(
             backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Destinations',style: TextStyle(color: Colors.black),),
          ),
            body: ListView.builder(
              physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: locationsList.length,
              itemBuilder: (context, index) {
                return BStudentLocationItem(
                  location: locationsList[index],
                );
              },
            ),
          );
        }
        if (state is BGetLocationsFailure) {
          return Scaffold(
             backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title:  const Text('Destinations',style: TextStyle(color: Colors.black),),
          ),
              body: Center(child: Text(state.errorMessage)));
        } else {
          return Scaffold(
             backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Destinations',style: TextStyle(color: Colors.black),),
          ),
              body: const Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
