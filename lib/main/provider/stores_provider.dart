import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:stores_app/external/database/database_service.dart';
part 'stores_provider.g.dart';

@riverpod
class Stores extends _$Stores{

List? stores =[];
@override
FutureOr<List> build()=>stores??[];


Future<List> getStoresStores ()async{
  state =AsyncLoading();
  DatabaseService _database = DatabaseService.instance;
  stores = await _database.getStores();
  state =AsyncData(stores!);
  return stores!;
}
}