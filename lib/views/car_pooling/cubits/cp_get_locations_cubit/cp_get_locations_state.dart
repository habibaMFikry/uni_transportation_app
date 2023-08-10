part of 'cp_get_locations_cubit.dart';

@immutable
abstract class CpGetLocationsState {}

class CpGetLocationsInitial extends CpGetLocationsState {}

class CpGetLocationsLoading extends CpGetLocationsState {}

class CpGetLocationsSuccess extends CpGetLocationsState {}

class CpGetLocationsFailure extends CpGetLocationsState {
  final String errorMessage;
  CpGetLocationsFailure({required this.errorMessage});
}
