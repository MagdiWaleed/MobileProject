import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'test_provider.g.dart';

@riverpod
class Test extends _$Test{
  @override
  int build()=>0;

  void increment(){
    state++;
  }
}
  