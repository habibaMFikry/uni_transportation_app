import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/b_get_locations_cubit/b_get_locations_cubit.dart';
import '../models/b_locations.dart';
import 'widgets/b_driver_location_item.dart';

class BDriverLocation extends StatelessWidget {
  const BDriverLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BGetLocationsCubit, BGetLocationsState>(
      builder: (context, state) {
        List<BLocations> locationsList =
            BlocProvider.of<BGetLocationsCubit>(context).driverLocationsList;
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
                return BDriverLocationItem(
                  location: locationsList[index],
                );
              },
            ),
          );
        }
        if (state is BGetLocationsFailure) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Locations'),
                centerTitle: true,
              ),
              body: Center(child: Text(state.errorMessage)));
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Locations'),
                centerTitle: true,
              ),
              body: const Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
