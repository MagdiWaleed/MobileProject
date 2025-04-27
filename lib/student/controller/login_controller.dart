import 'package:flutter/material.dart';
import 'package:stores_app/student/controller/service/bloc/student_bloc.dart';
import 'package:stores_app/main/view/main_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginController {
  final GlobalKey<FormState> formstate = GlobalKey();

  final List<TextEditingController> textFieldControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final StudentBloc studentBloc = StudentBloc();

  StudentContorller() {}
  void login() {
    final Map<String, dynamic> data = {
      "email": textFieldControllers[0].value.text,
      "password": textFieldControllers[1].value.text,
    };

    studentBloc.add(StudentLoginEvent(studentData: data));
  }

  void showLoginState(StudentState state, BuildContext context) {
    switch (state.runtimeType) {
      case StudentLoginSuccessfullState:
        state = state as StudentLoginSuccessfullState;
        {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: state.message),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainView()),
          );
        }
      case StudentLoginFailedState:
        {
          state = state as StudentLoginFailedState;
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.errorMessage),
          );
        }
    }
  }
}
