import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/b_student.dart';

part 'b_get_student_info_state.dart';

class BGetStudentInfoCubit extends Cubit<BGetStudentInfoState> {
  BGetStudentInfoCubit() : super(BGetStudentInfoInitial());

  BStudent studentData = BStudent(
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    phoneNumber: '',
  );

  Future<void> getStudentInfo({String? studentID}) async {
    emit(BGetStudentInfoLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Bus_students')
          .doc(studentID ?? FirebaseAuth.instance.currentUser!.uid)
          .get();

      Map<dynamic, dynamic> json = doc.data()as Map<dynamic, dynamic>;
      studentData = BStudent.fromJson(json);

      emit(BGetStudentInfoSuccess());
    } on FirebaseAuthException catch (e) {
      emit(BGetStudentInfoFailure(errorMessage: e.message.toString()));
    }
  }

  Future<void> editStudentInfo(BStudent studentModel) async {
    await FirebaseFirestore.instance
        .collection('Bus_students')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'first name': studentModel.firstName,
      'last name': studentModel.lastName,
      'phone number': studentModel.phoneNumber,
    });
  }
}
