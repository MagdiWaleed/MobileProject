import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/main/services/main_profile_service/main_profile_bloc.dart';
import 'package:stores_app/student/controller/service/bloc/student_bloc.dart';
import 'package:stores_app/student/views/profile_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MainProfileView extends StatelessWidget {
  final MainProfileBloc mainProfileBloc;

  const MainProfileView({super.key, required this.mainProfileBloc});
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainProfileBloc, MainProfileState>(
      bloc: mainProfileBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case MainProfileGetDataLoadingState:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomLoading()],
            );

          case MainProfileGetDataSuccessState:
            state = state as MainProfileGetDataSuccessState;
            final studentData = state.studentData;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
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
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          "${AppData.SERVER_URL}/${studentData.profile_pic_path}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                          height: 80,
                          width: 80,
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Name and Email text
                      Text(
                        studentData.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(studentData.email, style: TextStyle(fontSize: 16)),

                      const SizedBox(height: 20),
                      // Profile button
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProfilePage(studentData: studentData),
                            ),
                          );
                          print(result);
                          if (result == true) {
                            mainProfileBloc.add(MainProfileGetDataEvent());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "View Profile",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );

          case MainProfileGetDataFailedState:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("an Error Occure")],
                ),
              ],
            );
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CustomLoading()],
            );
        }
      },
      listener: (context, state) {
        switch (state.runtimeType) {
          case MainProfileGetDataFailedState:
            {
              state = state as MainProfileGetDataFailedState;
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(message: state.errorMessage),
              );
            }
        }
      },
    );
  }
}
