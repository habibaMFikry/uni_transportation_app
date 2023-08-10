part of 'b_login_cubit.dart';

@immutable
abstract class BLoginState {}

class BLoginInitial extends BLoginState {}

class BLoginLoading extends BLoginState {}

class BLoginSuccess extends BLoginState {}

class BLoginFailure extends BLoginState {
  final String errorMessage;
  BLoginFailure({required this.errorMessage});
}
