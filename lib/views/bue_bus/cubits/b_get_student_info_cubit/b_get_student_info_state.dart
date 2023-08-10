part of 'b_get_student_info_cubit.dart';

@immutable
abstract class BGetStudentInfoState {}

class BGetStudentInfoInitial extends BGetStudentInfoState {}

class BGetStudentInfoLoading extends BGetStudentInfoState {}

class BGetStudentInfoSuccess extends BGetStudentInfoState {}

class BGetStudentInfoFailure extends BGetStudentInfoState {
  final String errorMessage;
  BGetStudentInfoFailure({required this.errorMessage});
}
