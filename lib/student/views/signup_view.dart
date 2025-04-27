import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stores_app/student/controller/service/bloc/student_bloc.dart';
import 'package:stores_app/student/controller/signup_controller.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/widget/custom_loading.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final SignupController _controller = SignupController();
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> subPages = [
      // Page 1: Email and Student ID
      Form(
        key: _formKeyPage1,
        child: Column(
          children: [
            const Text("Please fill out the following fields"),
            const SizedBox(height: 15),
            TextFormField(
              controller: _controller.textFieldControllers[0],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldColor,
                labelText: "Email",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^\d+@stud\.fci-cu\.edu\.eg$',
                ).hasMatch(value.trim())) {
                  return 'Email must be in the format \n studentID@stud.fci-cu.edu.eg';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.textFieldControllers[1],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldColor,
                labelText: "Student ID",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your student ID';
                }
                if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                  return 'Student ID must be a number';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Step 1 of 3"),
                TextButton(
                  onPressed: () {
                    if (_formKeyPage1.currentState!.validate()) {
                      String email =
                          _controller.textFieldControllers[0].text.trim();
                      String studentId =
                          _controller.textFieldControllers[1].text.trim();
                      String studentIdFromEmail = email.split('@')[0];
                      if (studentIdFromEmail == studentId) {
                        _controller.nextPage();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Student ID does not match the email',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(fontSize: 16, color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Page 2: Name, Password, and Confirm Password
      Form(
        key: _formKeyPage2,
        child: Column(
          children: [
            const Text("Please fill out the following fields"),
            const SizedBox(height: 15),
            TextFormField(
              controller: _controller.textFieldControllers[2],
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldColor,
                labelText: "Name",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.textFieldControllers[3],
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldColor,
                labelText: "Password",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                if (!RegExp(r'\d').hasMatch(value)) {
                  return 'Password must contain at least one number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.textFieldControllers[4],
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textFieldColor,
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _controller.textFieldControllers[3].text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Step 2 of 3"),
                TextButton(
                  onPressed: () {
                    if (_formKeyPage2.currentState!.validate()) {
                      _controller.nextPage();
                    }
                  },
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(fontSize: 16, color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Page 3: Gender and Level Selection
      Column(
        children: [
          const Text("Select Your Preferences"),
          const SizedBox(height: 10),
          const Text(
            "Gender:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: "Male",
                groupValue: _controller.selectedGender,
                onChanged: (value) {
                  setState(() {
                    _controller.selectedGender = value!;
                  });
                },
              ),
              const Text("Male"),
              const SizedBox(width: 20),
              Radio<String>(
                value: "Female",
                groupValue: _controller.selectedGender,
                onChanged: (value) {
                  setState(() {
                    _controller.selectedGender = value!;
                  });
                },
              ),
              const Text("Female"),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Select Your Level:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: List.generate(4, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<int>(
                    value: index + 1,
                    groupValue: _controller.selectedLevel,
                    onChanged: (value) {
                      setState(() {
                        _controller.selectedLevel = value!;
                      });
                    },
                  ),
                  Text("Level ${index + 1}"),
                ],
              );
            }),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _controller.selectedGender = null;
                    _controller.selectedLevel = null;
                  });
                },
                child: const Text(
                  "Clear",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _controller.signup();
              },
              child: Text(
                "FINISH",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Step 3 of 3")],
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top Blue Container
          Container(
            height: 350,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          // Title
          const Positioned(
            top: 60,
            left: 30,
            child: Text(
              "Create Account",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Logo
          Positioned(
            top: 50,
            right: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/images/logo.png', height: 60),
            ),
          ),
          // Signup Card
          PageView(
            controller: _controller.pageController,
            onPageChanged: (value) {
              setState(() {
                _controller.currentPage = value;
              });
            },
            children: [
              for (int i = 0; i < 3; i++)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 330,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [subPages[i]],
                    ),
                  ),
                ),
            ],
          ),
          BlocConsumer<StudentBloc, StudentState>(
            bloc: _controller.studentBloc,
            builder: (context, state) {
              switch (state.runtimeType) {
                case StudentSignupLoadingState:
                  {
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: CustomLoading(),
                    );
                  }
                default:
                  {
                    return Container();
                  }
              }
            },
            listener: (context, state) {
              _controller.showSignupState(state, context);
            },
          ),
        ],
      ),
    );
  }
}
