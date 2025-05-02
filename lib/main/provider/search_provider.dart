import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:stores_app/external/database/database_service.dart';
import 'package:stores_app/external/model/product_model.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:stores_app/main/provider/stores_provider.dart';
part 'search_provider.g.dart';

@riverpod
class Search extends _$Search{
final DatabaseService _database = DatabaseService.instance;

@override
FutureOr<List> build() async{
  final List<StoreModel>? stores = await _database.getStores();
  for (int i =0; i< stores!.length; i++){
    List<ProductModel> products = await _database.getStoreProducts(stores[i].id);
     print(products);
    stores[i].products = products;
    }
  print(stores);
  return stores;
}


Future<List> getStoresSearchStores (String productName) async{
  state =AsyncLoading();
  final List? stores = await _database.getStores();
  state =AsyncData(stores!);
  return stores;
}
}
