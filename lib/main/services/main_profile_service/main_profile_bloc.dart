import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stores_app/main/services/main_profile_service/repo/main_profile_repo.dart';
import 'package:stores_app/external/model/user_model.dart';
import 'package:meta/meta.dart';

part 'main_profile_event.dart';
part 'main_profile_state.dart';

class MainProfileBloc extends Bloc<MainProfileEvent, MainProfileState> {
  MainProfileBloc() : super(MainProfileInitial()) {
    on<MainProfileGetDataEvent>(mainProfileGetData);
  }

  FutureOr<void> mainProfileGetData(
    MainProfileGetDataEvent event,
    Emitter<MainProfileState> emit,
  ) async {
    emit(MainProfileGetDataLoadingState());
    final Map<String, dynamic> response =
        await MainProfileRepo.getStudentData();

    if (response['status']) {
      final studentModel = StudentModel.fromResponse(response);
      emit(MainProfileGetDataSuccessState(studentData: studentModel));
    } else {
      emit(MainProfileGetDataFailedState(errorMessage: response['error']));
    }
  }
}
