import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';
import '../models/cp_ride.dart';
import '../cubits/cp_ride_cubit/cp_ride_cubit.dart';
import '../models/cp_user.dart';
import 'widgets/cp_passenger_list_item.dart';

class CpPassengerRideList extends StatelessWidget {
  static const routeName = 'cp-passenger-ride-list';

  const CpPassengerRideList({super.key});

  Future<void> refreshfun(BuildContext context) async {
    CpRide rideInfo = ModalRoute.of(context)!.settings.arguments as CpRide;
    await BlocProvider.of<CpRideCubit>(context).getRidesAndDriverInfo(
      start: rideInfo.startLocation,
      des: rideInfo.destinationLocation,
      time: rideInfo.rideTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CpRideCubit, CpRideState>(
      builder: (context, state) {
        List<CpRide> filteredRides =
            BlocProvider.of<CpRideCubit>(context).filteredRides;

        List<CpUser> driversList =
            BlocProvider.of<CpRideCubit>(context).usersList;

        CpUser passenger =
            BlocProvider.of<CpGetUserInfoCubit>(context).userData;

        if (state is CpRideSuccess) {
          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Rides',style: TextStyle(color: Colors.black),
          ),
          ),
            body: filteredRides.isEmpty
                ? const Center(
                    child: Text('No rides'),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshfun(context),
                    child: ListView.builder(
                      physics:
                          const ScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: driversList.length,
                      itemBuilder: (context, index) {
                        return CpPassengerListItem(
                          passengerInfo: passenger,
                          rideInfo: filteredRides[index],
                          driverInfo: driversList[index],
                        );
                      },
                     
                    ),
                  ),
          );
        }
        if (state is CpRideFailure) {
          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Rides',style: TextStyle(color: Colors.black),
          ),
          ),
              body: Center(child: Text(state.errorMessage)));
        } else {
          return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Rides',style: TextStyle(color: Colors.black),
          ),
          ),
              body: const Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
