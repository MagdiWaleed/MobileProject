import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stores_app/student/repo/student_repo.dart';
part "login_provider.g.dart";


@riverpod
class LoginProvider extends _$LoginProvider{
  
  @override
  FutureOr<String> build() {
    return "";
  }

  
  
  FutureOr<void>  login(String email, String password) async{
      try {
      state = const AsyncLoading(); 
      final Map<String, dynamic> response = await StudentRepo.login(email, password);
      if (!response["status"]) {
        throw response['error'];
      }
      state = AsyncData(response["message"]); 
    } catch (e, st) {
      state = AsyncError(e, st); 
    }
    

  }
}