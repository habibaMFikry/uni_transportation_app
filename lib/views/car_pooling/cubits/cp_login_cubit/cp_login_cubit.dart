import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cp_login_state.dart';

class CPLoginCubit extends Cubit<CPLoginState> {
  CPLoginCubit(this._auth) : super(CPLoginInitial());

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<void> cpLogin(
      {required String email, required String password}) async {
    emit(CPLoginLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      emit(CPLoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(CPLoginFailure(errorMessage: e.message.toString()));
    }
  }
}
