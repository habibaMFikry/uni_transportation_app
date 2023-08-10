import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cp_locations.dart';
import '../cubits/cp_get_locations_cubit/cp_get_locations_cubit.dart';
import 'widgets/cp_passenger_location_item.dart';

class CpPassengerLocations extends StatelessWidget {
  static const routeName = 'cp-passenger-locations-view';
  const CpPassengerLocations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CpGetLocationsCubit, CpGetLocationsState>(
      builder: (context, state) {
        List<CpLocations> locationsList =
            BlocProvider.of<CpGetLocationsCubit>(context).locationList;
        if (state is CpGetLocationsSuccess) {
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
                return CpPassengerLocationItem(
                  location: locationsList[index],
                );
              },
            ),
          );
        }
        if (state is CpGetLocationsFailure) {
          return Scaffold(
             backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Destinations',style: TextStyle(color: Colors.black),),
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
