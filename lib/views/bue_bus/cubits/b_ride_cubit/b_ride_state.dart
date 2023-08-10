part of 'b_ride_cubit.dart';

@immutable
abstract class BRideState {}

class BRideInitial extends BRideState {}

class BRideLoading extends BRideState {}

class BRideSuccess extends BRideState {}

class BRideFailure extends BRideState {
  final String errorMessage;
  BRideFailure({required this.errorMessage});
}
