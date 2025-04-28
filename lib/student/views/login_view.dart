import 'package:flutter/material.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/student/provider/login_provider.dart';
import 'package:stores_app/student/views/signup_view.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginPage extends  ConsumerWidget{
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();
  
  final List<TextEditingController> textFieldControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loginState = ref.watch(loginProviderProvider);
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

          // Welcome Text
          Positioned(
            top: 60,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),

          // Logo
          Positioned(
            top: 50,
            right: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                height: 60,
              ),
            ),
          ),

          // Login Card with Padding
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Email TextField
                    TextFormField(
                      controller: textFieldControllers[0],
                      textInputAction: TextInputAction.next,
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
                          return 'Please enter a valid email in the format\n studentID@stud.fci-cu.edu.eg';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Password TextField
                    TextFormField(
                      controller: textFieldControllers[1],
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Login Button
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()){
                            try{
                              await ref.read(loginProviderProvider.notifier).login(textFieldControllers[0].text, textFieldControllers[1].text);
                            }catch(e) {
                               showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(message: e.toString()),
                              );
                            }
                            
                          }
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //sign up Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
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
          
          loginState.when(data:(message) {
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.error(message: message),
                );
            return Container();
            }, error: (e,errorTree){
              
              return Container();
              }, loading: (){
                

                  return Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: CustomLoading(),
                  );
              })
          
        ],
      ),
    );
  }
}
