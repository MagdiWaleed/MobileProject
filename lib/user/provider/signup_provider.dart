import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stores_app/user/repo/student_repo.dart';
part 'signup_provider.g.dart';

@riverpod
class Signup extends _$Signup {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> signup(Map<String, dynamic> studentData) async {
    try {
      state = AsyncLoading();
      final Map<String, dynamic> response = await StudentRepo.signup(
        studentData,
      );

      if (!response["status"]) {
        throw response['error'];
      }
      state = AsyncData(response["message"]);
      return response['message'];
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
