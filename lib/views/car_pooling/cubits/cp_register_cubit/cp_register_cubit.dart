import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cp_user.dart';

part 'cp_register_state.dart';

class CPRegisterCubit extends Cubit<CPRegisterState> {
  CPRegisterCubit(this._auth) : super(CPRegisterInitial());

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<void> cpRegister({required CpUser userModel}) async {
    emit(CPRegisterLoading());
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: userModel.email, password: userModel.password!)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('Carpooling users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(userModel.toJson());
      });

      emit(CPRegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(CPRegisterFailure(errorMessage: e.message.toString()));
    }
  }
}
