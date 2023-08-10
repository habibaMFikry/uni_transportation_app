import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/b_driver.dart';
import '../../models/b_ride.dart';

part 'b_ride_state.dart';

class BRideCubit extends Cubit<BRideState> {
  BRideCubit() : super(BRideInitial());

  bool dHasRide = false;
  bool pHasRide = false;

  List<BRide> ridesList = [];
  List<BRide> filteredRides = [];
  List<BDriver> usersList = [];
  BRide ride = BRide(
    busID: 0,
    destinationLocation: '',
    startLocation: '',
    stopPoints: null,
    time:'',
  );
  BDriver driver = BDriver(
    busId: 0,
    name: '',
    password: 0,
    phoneNumber: '',
  );
  BRide passRide = BRide(
    busID: 0,
    destinationLocation: '',
    startLocation: '',
    stopPoints: null,
    time:'',
  );

  Future<void> saveRide({required BRide rideModel}) async {
    emit(BRideLoading());
    try {
      await FirebaseFirestore.instance
          .collection('Bus_rides')
          .doc(rideModel.busID.toString())
          .set(rideModel.toJson());

      emit(BRideSuccess());
    } catch (e) {
      emit(BRideFailure(errorMessage: e.toString()));
    }
  }

  Future<BRide> getRide(int busID) async {
    emit(BRideLoading());
    try {
      ridesList.clear();
      final rideDoc =
          await FirebaseFirestore.instance.collection('Bus_rides').get();
      for (var element in rideDoc.docs) {
        ridesList.add(BRide.fromJson(element.data()));
      }
      for (var element in ridesList) {
        if (element.busID == busID) {
          ride = element;
        }
      }

      emit(BRideSuccess());
      return ride;
    } catch (e) {
      emit(BRideFailure(errorMessage: e.toString()));
      return ride;
    }
  }

  Future<void> getRideAndDriverInfo(
      {required String start, required String des}) async {
    emit(BRideLoading());
    try {
      ridesList.clear();
      final rideDoc =
          await FirebaseFirestore.instance.collection('Bus_rides').get();
      for (var element in rideDoc.docs) {
        ridesList.add(BRide.fromJson(element.data()));
      }

      ride = BRide(
        busID: 0,
        destinationLocation: '',
        startLocation: '',
        stopPoints: null,
        time:'',
      );
      for (var element in ridesList) {
        if (element.startLocation == start &&
            element.destinationLocation == des) {
          ride = element;
        }
      }
      driver = BDriver(
        busId: 0,
        name: '',
        password: 0,
        phoneNumber: '',
      );
      final userDoc = await FirebaseFirestore.instance
          .collection('Bus_drivers')
          .doc('Driver${ride.busID.toString()}')
          .get();
      Map<dynamic, dynamic> json = userDoc.data() as Map<dynamic, dynamic>;
      driver = BDriver.fromJson(json);
      //}

      emit(BRideSuccess());
    } catch (e) {
      emit(BRideFailure(errorMessage: e.toString()));
    }
  }

  Future<void> checkStudentRide() async {
    emit(BRideLoading());
    try {
      ridesList.clear();
      final rideDoc =
          await FirebaseFirestore.instance.collection('Bus_rides').get();
      for (var element in rideDoc.docs) {
        ridesList.add(BRide.fromJson(element.data()));
      }
      pHasRide = false;
      var currentUser = FirebaseAuth.instance.currentUser!.uid;
      for (int i = 0; i <= ridesList.length; i++) {
        if (ridesList[i].students != null) {
          for (var element in ridesList[i].students) {
            if (currentUser == element['uid']) {
              pHasRide = true;
              passRide = ridesList[i];
              final doc = await FirebaseFirestore.instance
                  .collection('Bus_drivers')
                  .doc('Driver${passRide.busID.toString()}')
                  .get();

              Map<dynamic, dynamic> json = doc.data() as Map<dynamic, dynamic>;
              driver = BDriver.fromJson(json);
              return;
            }
          }
        } else {
          pHasRide = false;
        }
      }

      emit(BRideSuccess());
    } catch (e) {
      emit(BRideFailure(errorMessage: e.toString()));
    }
  }

  Future<bool> checkBDriverRide(int busID) async {
    emit(BRideLoading());
    try {
      ridesList.clear();
      final rideDoc =
          await FirebaseFirestore.instance.collection('Bus_rides').get();
      for (var element in rideDoc.docs) {
        ridesList.add(BRide.fromJson(element.data()));
      }
      for (int i = 0; i <= ridesList.length; i++) {
        if (busID == ridesList[i].busID) {
          dHasRide = true;
          return dHasRide;
        } else {
          dHasRide = false;
        }
      }
      emit(BRideSuccess());
      return dHasRide;
    } catch (e) {
      dHasRide = false;
      emit(BRideFailure(errorMessage: e.toString()));
      return dHasRide;
    }
  }

  Future<void> deleteRide(int busID) async {
    await FirebaseFirestore.instance
        .collection('Bus_rides')
        .doc(busID.toString())
        .delete();
  }
}
