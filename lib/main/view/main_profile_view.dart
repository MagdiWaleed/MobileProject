import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/external/theme/app_colors.dart';
import 'package:stores_app/external/widget/custom_loading.dart';
import 'package:stores_app/main/provider/main_profile_provider.dart';
import 'package:stores_app/user/views/profile_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MainProfileView extends ConsumerWidget {
  const MainProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(studentProfileProvider);

    return profileAsync.when(
      loading: () => const Center(child: CustomLoading()),
      error:
          (error, stack) =>
              Center(child: Text("An error occurred: ${error.toString()}")),
      data: (studentData) {
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
                  Text(
                    studentData.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(studentData.email, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ProfilePage(studentData: studentData),
                        ),
                      );
                      if (result == true) {
                        ref.refresh(studentProfileProvider);
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
      },
    );
  }
}
