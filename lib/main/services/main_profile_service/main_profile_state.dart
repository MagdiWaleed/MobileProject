part of 'main_profile_bloc.dart';

@immutable
sealed class MainProfileState {}

final class MainProfileInitial extends MainProfileState {}


class MainProfileGetDataLoadingState extends MainProfileState{
}

class MainProfileGetDataSuccessState extends MainProfileState{
 final StudentModel studentData;
  MainProfileGetDataSuccessState({required this.studentData});

}

class MainProfileGetDataFailedState extends MainProfileState{
  final String errorMessage;
  MainProfileGetDataFailedState({required this.errorMessage});
}


