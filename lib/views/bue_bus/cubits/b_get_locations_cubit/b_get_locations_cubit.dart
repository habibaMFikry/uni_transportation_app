import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/b_locations.dart';

part 'b_get_locations_state.dart';

class BGetLocationsCubit extends Cubit<BGetLocationsState> {
  BGetLocationsCubit() : super(BGetLocationsInitial());

  List<BLocations> locationList = [];
  List<BLocations> driverLocationsList = [];

  Future<void> bGetLocations() async {
    emit(BGetLocationsLoading());
    try {
      locationList.clear();
      final doc =
          await FirebaseFirestore.instance.collection('Bus_Locations').get();
      var json = doc.docs;
      for (var key in json) {
        locationList.add(BLocations.fromJson(key));
      }
      locationList.sort((a, b) {
        return a.startLocation
            .toLowerCase()
            .compareTo(b.startLocation.toLowerCase());
      });
      emit(BGetLocationsSuccess());
    } catch (e) {
      emit(BGetLocationsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> bGetDriverLocations(int busId) async {
    emit(BGetLocationsLoading());
    try {
      locationList.clear();
      final doc =
          await FirebaseFirestore.instance.collection('Bus_Locations').get();
      var json = doc.docs;
      for (var key in json) {
        locationList.add(BLocations.fromJson(key));
      }
      driverLocationsList.clear();
      for (var elmenet in locationList) {
        if (elmenet.busId == busId) {
          driverLocationsList.add(elmenet);
        }
      }
      emit(BGetLocationsSuccess());
    } catch (e) {
      emit(BGetLocationsFailure(errorMessage: e.toString()));
    }
  }
}
