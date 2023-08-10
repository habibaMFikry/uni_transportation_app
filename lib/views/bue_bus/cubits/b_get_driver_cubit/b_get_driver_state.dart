part of 'b_get_driver_cubit.dart';

@immutable
abstract class BGetDriverState {}

class BGetDriverInitial extends BGetDriverState {}

class BGetDriverLoading extends BGetDriverState {}

class BGetDriverSuccess extends BGetDriverState {}

class BGetDriverFailure extends BGetDriverState {
  final String errorMessage;
  BGetDriverFailure({required this.errorMessage});
}
