part of 'cp_register_cubit.dart';

@immutable
abstract class CPRegisterState {}

class CPRegisterInitial extends CPRegisterState {}

class CPRegisterLoading extends CPRegisterState {}

class CPRegisterSuccess extends CPRegisterState {}

class CPRegisterFailure extends CPRegisterState {
  final String errorMessage;
  CPRegisterFailure({required this.errorMessage});
}
