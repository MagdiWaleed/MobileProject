import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stores_app/external/model/user_model.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/user/provider/update_student_provider.dart';
import 'package:stores_app/user/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileController {
  final GlobalKey<FormState> formstate = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  StudentModel? studentData;
  final PageController pageController = PageController();
  int currentPage = 0;
  String? selectedGender;
  int? selectedLevel;
  File? image;
  bool deleteImage = false;

  Map<String, dynamic>? studentDataMap;

  void init(StudentModel studentData) {
    nameController.text = studentData.name;
    emailController.text = studentData.email;
    passwordController.text = studentData.password;
    confirmPasswordController.text = studentData.password;
    selectedGender = studentData.gender;
    selectedLevel = studentData.level;
    this.studentData = studentData;
  }

  void logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void deleteAccount() {}

  void updateData(WidgetRef ref) {
    studentDataMap = {
      'profile_pic_path':
          image?.path == null ? (deleteImage ? "DELETE" : "#") : image!.path,
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "student_id": int.parse(studentIdController.text),
      "level": selectedLevel,
      "gender":
          selectedGender == null ? null : (selectedGender == "Male" ? 0 : 1),
    };

    // استدعاء FutureProvider
    ref.read(updateStudentProvider(studentDataMap!));
  }
}
