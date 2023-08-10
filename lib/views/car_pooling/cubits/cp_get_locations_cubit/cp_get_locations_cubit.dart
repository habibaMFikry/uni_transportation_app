import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cp_locations.dart';

part 'cp_get_locations_state.dart';

class CpGetLocationsCubit extends Cubit<CpGetLocationsState> {
  CpGetLocationsCubit() : super(CpGetLocationsInitial());

  List<CpLocations> locationList = [];

  Future<void> getLocations() async {
    emit(CpGetLocationsLoading());
    try {
      locationList.clear();
      final doc = await FirebaseFirestore.instance
          .collection('Carpooling Locations')
          .get();

      var json = doc.docs;
      for (var key in json) {
        locationList.add(CpLocations.fromJson(key));
      }
      locationList.sort((a, b) {
        return a.startLocation
            .toLowerCase()
            .compareTo(b.startLocation.toLowerCase());
      });
      emit(CpGetLocationsSuccess());
    } catch (e) {
      emit(CpGetLocationsFailure(errorMessage: e.toString()));
    }
  }
}
