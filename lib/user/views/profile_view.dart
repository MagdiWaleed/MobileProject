import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stores_app/user/controller/profile_controller.dart';
import 'package:stores_app/external/model/user_model.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/user/provider/update_student_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage({super.key, required this.studentData});
  final StudentModel studentData;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  final ProfileController _controller = ProfileController();
  final _formKey = GlobalKey<FormState>();

  void removeImage() {
    setState(() {
      _controller.image = null;
      widget.studentData.profile_pic_path = null;
      _controller.deleteImage = true;
    });
  }

  Future<void> _PICKIMAGE(bool is_camera) async {
    final pickedFile = await ImagePicker().pickImage(
      source: is_camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _controller.image = File(pickedFile.path);
        widget.studentData.profile_pic_path = _controller.image!.path;
        _controller.deleteImage = false;
      });
    }
  }

  void pickImage(BuildContext context) async {
    showModalBottomSheet(
      isDismissible: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: ListTile(
                  title: Text("Camera"),
                  onTap: () {
                    _PICKIMAGE(true);
                    Navigator.pop(context);
                  },
                  trailing: Icon(Icons.camera),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(border: Border.all(width: 0.1)),
                child: ListTile(
                  title: Text("Gallery"),
                  onTap: () {
                    _PICKIMAGE(false);
                    Navigator.pop(context);
                  },
                  trailing: Icon(Icons.image),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    setState(() {
      _controller.init(widget.studentData);
    });
    super.initState();
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          const Positioned(
            top: 60,
            left: 40,
            child: Text(
              "Profile",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/images/logo.png', height: 60),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Container(
                  width: 330,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 5),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickImage(context);
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child:
                                    _controller.image != null
                                        ? Image.file(
                                          _controller.image!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.network(
                                          "${AppData.SERVER_URL}/${widget.studentData.profile_pic_path ?? "DEFAULT_PROFILE_IMAGE"}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          key: UniqueKey(),
                                        ),
                              ),
                              widget.studentData.profile_pic_path != null
                                  ? Positioned(
                                    right: -5,
                                    top: -5,
                                    child: IconButton(
                                      onPressed: () {
                                        removeImage();
                                      },
                                      icon: Icon(
                                        Icons.highlight_remove_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                  : Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Icon(Icons.edit),
                                  ),
                            ],
                          ),
                        ),
                        const Text(
                          "Tap to change the image",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _controller.nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
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
                          controller: _controller.emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^\d+@stud\.fci-cu\.edu\.eg$',
                            ).hasMatch(value.trim())) {
                              return 'Email must be in the format of \nstudentId@stud.fci-cu.edu.eg';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _controller.studentIdController,
                          decoration: InputDecoration(
                            labelText: "Student ID",
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your student ID';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                              return 'Student ID must be a number';
                            }
                            String email =
                                _controller.emailController.text.trim();
                            String studentIdFromEmail = email.split('@')[0];
                            if (studentIdFromEmail != value.trim()) {
                              return 'Student ID does not match the email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _controller.passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
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
                          controller: _controller.confirmPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _controller.passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Gender:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: "Male",
                                    groupValue: _controller.selectedGender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _controller.selectedGender = value;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    fillColor: WidgetStateProperty.resolveWith(
                                      (states) => Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Male",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Radio<String>(
                                    value: "Female",
                                    groupValue: _controller.selectedGender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _controller.selectedGender = value;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    fillColor: WidgetStateProperty.resolveWith(
                                      (states) => Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Female",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Level:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Wrap(
                                spacing: 10,
                                children: List.generate(4, (index) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<int>(
                                        value: index + 1,
                                        groupValue: _controller.selectedLevel,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _controller.selectedLevel = value;
                                          });
                                        },
                                        activeColor: Colors.white,
                                        fillColor:
                                            WidgetStateProperty.resolveWith(
                                              (states) => Colors.white,
                                            ),
                                      ),
                                      Text(
                                        "Level ${index + 1}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _controller.selectedGender = null;
                                      _controller.selectedLevel = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                  ),
                                  child: const Text("Clear"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _controller.updateData(ref);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Expanded(
                            //   flex: 3,
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       _controller.logout(context);
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: Colors.redAccent,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //     ),
                            //     child: const Text(
                            //       "Logout",
                            //       style: TextStyle(
                            //         fontSize: 16,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              if (_controller.studentDataMap == null) {
                return Container();
              }
              final updateFuture = ref.watch(
                updateStudentProvider(_controller.studentDataMap!),
              );
              return updateFuture.when(
                data: (message) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(message: message),
                    );
                    Navigator.pop(context, true);
                  });
                  return Container();
                },
                loading:
                    () => const Positioned.fill(
                      child: Center(child: CustomLoading()),
                    ),
                error: (error, stack) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(message: error.toString()),
                    );
                  });
                  return Container();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
