import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/b_driver.dart';

part 'b_get_driver_state.dart';

class BGetDriverCubit extends Cubit<BGetDriverState> {
  BGetDriverCubit() : super(BGetDriverInitial());

  List<BDriver> driversList = [];
  BDriver driver = BDriver(
    busId: 0,
    name: '',
    password: 0,
    phoneNumber: '',
  );

  Future<void> bGetDriverInfo({required int busID}) async {
    emit(BGetDriverLoading());
    try {
      driversList.clear();
      final doc = await FirebaseFirestore.instance
          .collection('Bus_drivers')
          .doc('Driver$busID')
          .get();
      Map<dynamic, dynamic> json = doc.data() as Map<dynamic, dynamic>;
      driver = BDriver.fromJson(json);
      emit(BGetDriverSuccess());
    } catch (e) {
      emit(BGetDriverFailure(errorMessage: e.toString()));
    }
  }

  Future<List<BDriver>> bGetDriversList() async {
    emit(BGetDriverLoading());
    try {
      driversList.clear();
      final doc =
          await FirebaseFirestore.instance.collection('Bus_drivers').get();
      for (var element in doc.docs) {
        driversList.add(BDriver.fromJson(element.data()));
      }

      emit(BGetDriverSuccess());
      return driversList;
    } catch (e) {
      emit(BGetDriverFailure(errorMessage: e.toString()));
      return driversList;
    }
  }
}
