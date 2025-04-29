import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/main/view/main_view.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/user/provider/signup_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends ConsumerState<SignupPage> {
  
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
  final List<TextEditingController> textFieldControllers = [
    TextEditingController(), //email
    TextEditingController(), //id
    TextEditingController(), //name
    TextEditingController(), //password
    TextEditingController(), //confirm password
  ];

  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final PageController pageController =
              PageController(); 
  int currentPage = 0;

  String? selectedGender;
  int? selectedLevel;

  @override
  Widget build(BuildContext context) {
    ref.listen(signupProvider, (prev,next){
      next.whenOrNull(
        data: (data) {
        showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: data!.toString()),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainView()),
          );
      },
      error: (e,_)=>  showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: e.toString()),
          )
      );
    });
    final signupState = ref.watch(signupProvider);
    final List<Widget> subPages = [
      // Page 1: Email and Student ID
      Form(
        key: _formKeyPage1,
        child: Column(
          children: [
            const Text("Please fill out the following fields"),
            const SizedBox(height: 15),
            TextFormField(
              controller: textFieldControllers[0],
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
              controller: textFieldControllers[1],
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
                          textFieldControllers[0].text.trim();
                      String studentId =
                          textFieldControllers[1].text.trim();
                      String studentIdFromEmail = email.split('@')[0];
                      if (studentIdFromEmail == studentId) {
                        nextPage();
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
              controller: textFieldControllers[2],
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
              controller: textFieldControllers[3],
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
              controller: textFieldControllers[4],
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
                if (value != textFieldControllers[3].text) {
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
                      nextPage();
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
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
              const Text("Male"),
              const SizedBox(width: 20),
              Radio<String>(
                value: "Female",
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
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
                    groupValue: selectedLevel,
                    onChanged: (value) {
                      setState(() {
                        selectedLevel = value!;
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
                    selectedGender = null;
                    selectedLevel = null;
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
                final Map<String, dynamic> studentData = {
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
                    ref.read(signupProvider.notifier).signup(studentData);
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
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
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
          if(signupState.isLoading)
              Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: CustomLoading(),
                  
           
          ),
        ],
      ),
    );
  }
}
