import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stores_app/user/repo/student_repo.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial()) {
    on<StudentUpdateDataEvent>(studentUpdateDataEvent);
  }
  FutureOr<void> studentUpdateDataEvent(
    StudentUpdateDataEvent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentUpdateDataLoadingState());
    final Map<String, dynamic> response = await StudentRepo.updateStudentData(
      event.studentData,
    );

    if (response['status']) {
      print(response['message']);
      emit(StudentUpdateDataSuccessfullState(message: response['message']));
    } else {
      print(response['error']);
      emit(StudentUpdateDataFailedState(errorMessage: response['error']));
    }
  }
}
