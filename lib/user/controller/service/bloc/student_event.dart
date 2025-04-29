part of 'student_bloc.dart';

abstract class StudentEvent {}

class StudentSignupEvent extends StudentEvent {
  final Map<String,dynamic> studentData;

  StudentSignupEvent(this.studentData);

  List<Object> get props=>[studentData];
}

class StudentLoginEvent extends StudentEvent{
  final Map<String,dynamic> studentData;

  StudentLoginEvent({required this.studentData});
} 



class StudentUpdateDataEvent extends StudentEvent{
  final Map<String,dynamic> studentData;

  StudentUpdateDataEvent({required this.studentData});
}


class StudentDeleteAccountEvent extends StudentEvent{
}







