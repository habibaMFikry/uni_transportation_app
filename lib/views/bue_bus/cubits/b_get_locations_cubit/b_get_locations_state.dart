part of 'b_get_locations_cubit.dart';

@immutable
abstract class BGetLocationsState {}

class BGetLocationsInitial extends BGetLocationsState {}

class BGetLocationsLoading extends BGetLocationsState {}

class BGetLocationsSuccess extends BGetLocationsState {}

class BGetLocationsFailure extends BGetLocationsState {
  final String errorMessage;
  BGetLocationsFailure({required this.errorMessage});
}
