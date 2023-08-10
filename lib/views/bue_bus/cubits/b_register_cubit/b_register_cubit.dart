import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/b_student.dart';

part 'b_register_state.dart';

class BRegisterCubit extends Cubit<BRegisterState> {
  BRegisterCubit(this._auth) : super(BRegisterInitial());

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<void> bRegister({required BStudent studentModel}) async {
    emit(BRegisterLoading());
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: studentModel.email, password: studentModel.password!)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('Bus_students')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(studentModel.toJson());
      });

      emit(BRegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(BRegisterFailure(errorMessage: e.message.toString()));
    }
  }
}
