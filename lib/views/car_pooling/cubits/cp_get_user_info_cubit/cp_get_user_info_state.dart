part of 'cp_get_user_info_cubit.dart';

@immutable
abstract class CpGetUserInfoState {}

class CpGetUserInfoInitial extends CpGetUserInfoState {}

class CpGetUserInfoLoading extends CpGetUserInfoState {}

class CpGetUserInfoSuccess extends CpGetUserInfoState {}

class CpGetUserInfoFailure extends CpGetUserInfoState {
  final String errorMessage;
  CpGetUserInfoFailure({required this.errorMessage});
}
