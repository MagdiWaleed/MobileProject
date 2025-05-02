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
     stores[i].products = products;
    }
  return stores;
}

FutureOr<List> getInitialStoresList() async{
  state = AsyncLoading();
  late List<StoreModel>? stores;
  try{  stores= await _database.getStores();
  for (int i =0; i< stores!.length; i++){
    List<ProductModel> products = await _database.getStoreProducts(stores[i].id);
     stores[i].products = products;
    }
  }catch(e,et){
    state = AsyncError(e,et);
  }
  state = AsyncData(stores!);
  return stores;
}

Future<List> getStoresSearch (String productName) async{
  state =AsyncLoading();
  late List? stores;
  try{ stores= await _database.getStoresProductsMatching(productName);
  }catch(e,et){
    state = AsyncError(e, et);
  }
  state =AsyncData(stores!);
  return stores;
}

Future<Map<String,dynamic>> getInitialItemsList()async{
  state = AsyncLoading();
  final List<Map<String,dynamic>> uniqueProducts = [];
  final List<Map<String,dynamic>> data= [];

  try{
  final List<StoreModel>? stores = await _database.getStores();
  for (int i =0; i< stores!.length; i++){
    List<ProductModel> products = await _database.getStoreProducts(stores[i].id);
     stores[i].products = products;
    }
  for (StoreModel store in stores){
    for(ProductModel product in store.products){
      data.add({"product": product,"store":store});
      if (uniqueProducts.any((item) => 
          item['product'] == product.name && item['image'] == product.image)) {
        continue;
      }
      uniqueProducts.add({"product":product.name,"image":product.image});
    }
 }

  state = AsyncData([{"data":data,"unique product": uniqueProducts}]);
  }catch(error, stackTrace){
    state = AsyncError(error, stackTrace);
  }
  return {"data":data,"unique product": uniqueProducts};
}


Future<Map<String,dynamic>> getItemsSearch (String productName) async{
 state = AsyncLoading();
  final List<Map<String,dynamic>> uniqueProducts = [];
  final List<Map<String,dynamic>> data= [];

  try{
  final List? stores = await _database.getStoresProductsMatching(productName);
  for (StoreModel store in stores!){
    for(ProductModel product in store.products){
      data.add({"product": product,"store":store});
      if (uniqueProducts.any((item) => 
          item['product'] == product.name && item['image'] == product.image)) {
        continue;
      }
      uniqueProducts.add({"product":product.name,"image":product.image});
    }
 }

  state = AsyncData([{"data":data,"unique product": uniqueProducts}]);
  }catch(error, stackTrace){
    state = AsyncError(error, stackTrace);
  }
  return {"data":data,"unique product": uniqueProducts};
}
}
