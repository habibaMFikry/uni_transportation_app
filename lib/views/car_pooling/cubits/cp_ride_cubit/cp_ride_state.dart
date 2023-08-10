part of 'cp_ride_cubit.dart';

@immutable
abstract class CpRideState {}

class CpRideInitial extends CpRideState {}

class CpRideLoading extends CpRideState {}

class CpRideSuccess extends CpRideState {}

class CpRideFailure extends CpRideState {
  final String errorMessage;
  CpRideFailure({required this.errorMessage});
}
