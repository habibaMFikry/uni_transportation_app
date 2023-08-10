import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cp_user.dart';

part 'cp_get_user_info_state.dart';

class CpGetUserInfoCubit extends Cubit<CpGetUserInfoState> {
  CpGetUserInfoCubit() : super(CpGetUserInfoInitial());

  CpUser userData = CpUser(
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    phoneNumber: '',
  );

  Future<void> getUserInfo({String? userID}) async {
    emit(CpGetUserInfoLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Carpooling users')
          .doc(userID ?? FirebaseAuth.instance.currentUser!.uid)
          .get();

      Map<dynamic, dynamic> json = doc.data() as Map<dynamic, dynamic>;
      userData = CpUser.fromJson(json);

      emit(CpGetUserInfoSuccess());
    } on FirebaseAuthException catch (e) {
      emit(CpGetUserInfoFailure(errorMessage: e.message.toString()));
    }
  }

  Future<void> editUserInfo(CpUser userModel) async {
    await FirebaseFirestore.instance
        .collection('Carpooling users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'first name': userModel.firstName,
      'last name': userModel.lastName,
      'phone number': userModel.phoneNumber,
      'car type': userModel.carType,
    });
  }
}
