import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:stores_app/external/database/database_service.dart';
import 'package:stores_app/external/model/store_model.dart';
part 'stores_provider.g.dart';

@riverpod
class Stores extends _$Stores {
  @override
  Future<List> build() async {
    state = AsyncLoading();
    DatabaseService _database = DatabaseService.instance;
    final List<StoreModel>? stores = await _database.getStores();
    state = AsyncData(stores!);
    return stores;
  }
}
