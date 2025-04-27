part of 'student_bloc.dart';

abstract class StudentState {}  

final class StudentInitial extends StudentState {}





class StudentSignupLoadingState extends StudentState{}

class StudentSignupSuccessfullState extends StudentState{
  final String message;
  StudentSignupSuccessfullState({required this.message
  });
}

class StudentSignupFailedState extends StudentState{
  final String errorMessage;
  StudentSignupFailedState({required this.errorMessage});
}



class StudentLoginLoadingState extends StudentState{}

class StudentLoginSuccessfullState extends StudentState{
  final String message;
  StudentLoginSuccessfullState({required this.message});
}
  


class StudentLoginFailedState extends StudentState{
  final String errorMessage;
  StudentLoginFailedState({required this.errorMessage});
}





class StudentUpdateDataLoadingState extends StudentState{
}

class StudentUpdateDataSuccessfullState extends StudentState{
 final String message;
  StudentUpdateDataSuccessfullState({required this.message});

}

class StudentUpdateDataFailedState extends StudentState{
  final String errorMessage;
  StudentUpdateDataFailedState({required this.errorMessage});
}





