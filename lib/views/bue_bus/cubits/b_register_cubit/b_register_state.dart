part of 'b_register_cubit.dart';

@immutable
abstract class BRegisterState {}

class BRegisterInitial extends BRegisterState {}

class BRegisterLoading extends BRegisterState {}

class BRegisterSuccess extends BRegisterState {}

class BRegisterFailure extends BRegisterState {
  final String errorMessage;
  BRegisterFailure({required this.errorMessage});
}
