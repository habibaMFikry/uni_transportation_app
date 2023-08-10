part of 'cp_login_cubit.dart';

@immutable
abstract class CPLoginState {}

class CPLoginInitial extends CPLoginState {}

class CPLoginLoading extends CPLoginState {}

class CPLoginSuccess extends CPLoginState {}

class CPLoginFailure extends CPLoginState {
  final String errorMessage;
  CPLoginFailure({required this.errorMessage});
}
