import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cp_ride.dart';
import '../../models/cp_user.dart';

part 'cp_ride_state.dart';

class CpRideCubit extends Cubit<CpRideState> {
  CpRideCubit() : super(CpRideInitial());

  bool dHasRide = false;
  bool pHasRide = false;

  List<CpRide> ridesList = [];
  List<CpUser> usersList = [];
  List<CpRide> filteredRides = [];
  CpRide driverRide = CpRide(
    startLocation: '',
    rideTime: '',
    destinationLocation: '',
    nOfSeatsAvailable: 0,
  );

  CpRide passRide = CpRide(
    startLocation: '',
    rideTime: '',
    destinationLocation: '',
  );

  CpUser driverInfo = CpUser(
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    phoneNumber: '',
  );

  Future<void> saveRide({required CpRide rideModel}) async {
    emit(CpRideLoading());
    try {
      await FirebaseFirestore.instance
          .collection('Carpooling rides')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(rideModel.toJson());
      emit(CpRideSuccess());
      } catch (e) {
        emit(CpRideFailure(errorMessage: e.toString()));
      }
    }

  Future<void> checkDriverRide() async {
    emit(CpRideLoading());
    try {
      ridesList.clear();
      final rideDoc =
          await FirebaseFirestore.instance.collection('Carpooling rides').get();
      for (var element in rideDoc.docs) {
        ridesList.add(CpRide.fromJson(element.data()));
      }
      var currentUser = FirebaseAuth.instance.currentUser!.uid;
      for (int i = 0; i <= ridesList.length; i++) {
        if (currentUser == ridesList[i].driverID) {
          dHasRide = true;
          return;
        } else {
          dHasRide = false;
        }
      }
      emit(CpRideSuccess());
    } catch (e) {
      dHasRide = false;
      emit(CpRideFailure(errorMessage: e.toString()));
    }
  }

  Future<void> checkPassengerRide() async {
    emit(CpRideLoading());
    try {
      ridesList.clear();
      final rideDoc =
          await FirebaseFirestore.instance.collection('Carpooling rides').get();
      for (var element in rideDoc.docs) {
        ridesList.add(CpRide.fromJson(element.data()));
      }
      var currentUser = FirebaseAuth.instance.currentUser!.uid;
      for (int i = 0; i <= ridesList.length; i++) {
        if (ridesList[i].passengers != null) {
          for (var element in ridesList[i].passengers) {
            if (currentUser == element['uid']) {
              pHasRide = true;
              passRide = ridesList[i];
              final doc = await FirebaseFirestore.instance
                  .collection('Carpooling users')
                  .doc(passRide.driverID)
                  .get();

              Map<dynamic, dynamic> json = doc.data() as Map<dynamic, dynamic>;
              driverInfo = CpUser.fromJson(json);
              return;
            } 
          }
        } else {
          pHasRide = false;
        }
      }
      emit(CpRideSuccess());
    } catch (e) {
      emit(CpRideFailure(errorMessage: e.toString()));
    }
  }
  Future<void> getDriverRide({String? driverID}) async {
    emit(CpRideLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Carpooling rides')
          .doc(driverID ?? FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<dynamic, dynamic> json = doc.data() as Map<dynamic, dynamic>;
      driverRide = CpRide.fromJson(json);
      emit(CpRideSuccess());
    } catch (e) {
      emit(CpRideFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getRidesAndDriverInfo(
      {required String start,
      required String time,
      required String des}) async {
    emit(CpRideLoading());
    try {
      ridesList.clear();
      final rideDoc =
          await FirebaseFirestore.instance.collection('Carpooling rides').get();
      for (var element in rideDoc.docs) {
        ridesList.add(CpRide.fromJson(element.data()));
      }
      filteredRides.clear();
      for (var ride in ridesList) {
        if (ride.startLocation == start &&
            ride.destinationLocation == des &&
            ride.rideTime == time &&
            ride.nOfSeatsAvailable != 0) {
          filteredRides.add(ride);
        }
      }
      usersList.clear();
      for (var filteredRide in filteredRides) {
        if (filteredRide.driverID != FirebaseAuth.instance.currentUser!.uid) {
          final userDoc = await FirebaseFirestore.instance
              .collection('Carpooling users')
              .doc(filteredRide.driverID)
              .get();
          Map<dynamic, dynamic> json = userDoc.data() as Map<dynamic, dynamic>;
          usersList.add(CpUser.fromJson(json));
        }
      }
      emit(CpRideSuccess());
    } catch (e) {
      emit(CpRideFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteRide() async {
    await FirebaseFirestore.instance
        .collection('Carpooling rides')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }
}
