import 'package:flutter/material.dart';
import 'package:stores_app/student/controller/service/bloc/student_bloc.dart';
import 'package:stores_app/main/view/main_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignupController {
  final GlobalKey<FormState> formstate = GlobalKey();

  final List<TextEditingController> textFieldControllers = [
    TextEditingController(), //email
    TextEditingController(), //id
    TextEditingController(), //name
    TextEditingController(), //password
    TextEditingController(), //confirm password
  ];

  final StudentBloc studentBloc = StudentBloc();

  final PageController pageController =
      PageController(); // Controller for PageView
  int currentPage = 0;

  String? selectedGender;
  int? selectedLevel;

  void nextPage() {
    if (currentPage < 2) {
      currentPage++;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void signup() {
    final Map<String, dynamic> domy = {
      "name": textFieldControllers[2].value.text,
      "email": textFieldControllers[0].value.text,
      "student_id": int.parse(textFieldControllers[1].value.text),
      "password": textFieldControllers[3].value.text,
      "level": selectedLevel,
      "gender":
          selectedGender == null
              ? null
              : selectedGender == "Male"
              ? 0
              : 1,
    };
    studentBloc.add(StudentSignupEvent(domy));
  }

  void showSignupState(StudentState state, BuildContext context) {
    switch (state.runtimeType) {
      case StudentSignupSuccessfullState:
        {
          state = state as StudentSignupSuccessfullState;
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: state.message),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainView()),
          );
        }
      case StudentSignupFailedState:
        {
          state = state as StudentSignupFailedState;
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.errorMessage),
          );
        }
    }
  }
}
