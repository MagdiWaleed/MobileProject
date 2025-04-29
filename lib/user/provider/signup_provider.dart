import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stores_app/external/model/user_model.dart';
import 'package:stores_app/user/repo/student_repo.dart';
part 'signup_provider.g.dart';

@riverpod
class Signup extends _$Signup{

  @override
  FutureOr<String?> build(){}
  
  Future<void> signup(Map<String,dynamic> studentData)async{
    state = AsyncLoading();
    final Map<String,dynamic> response = await StudentRepo.signup(studentData);
    
      if (response["status"]){
        state = AsyncData(response["message"]);
        return response["message"];
      }else{
        throw response["error"];
      
    }
  }

}