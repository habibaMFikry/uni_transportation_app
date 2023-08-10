import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'b_login_state.dart';

class BLoginCubit extends Cubit<BLoginState> {
  BLoginCubit(this._auth) : super(BLoginInitial());

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<void> bLogin({required String email, required String password}) async {
    emit(BLoginLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      emit(BLoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(BLoginFailure(errorMessage: e.message.toString()));
    }
  }
}
