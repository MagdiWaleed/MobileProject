import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'main_provider.g.dart';

@riverpod
class Main extends _$Main {
  @override
  Future<void> build() async{} 

  Future<void> checkFloatingActionButton()async{
    final db = await SharedPreferences.getInstance();
    try{
      bool showit = await db.getBool("viewMapButton")!;
      if (showit){
        state = AsyncData(true);
      }else{
        throw showit;
      }
    }catch (e,et){
      state = AsyncError(e, et);
    } 

  } 
}
