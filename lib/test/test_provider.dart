import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/external/database/database_service.dart';
import 'package:stores_app/external/model/product_model.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:stores_app/test/repo/test_repo.dart';
part 'test_provider.g.dart';

@riverpod
class Test extends _$Test{
  @override
  int build()=>0;

  void increment(){
    state++;
  }
}

@riverpod
class GetStoresDataTest extends _$GetStoresDataTest{
  final DatabaseService _database = DatabaseService.instance; 
  @override
  FutureOr<List<StoreModel>> build()=> [];

  Future<void> FetchStoresData() async{
    state = AsyncLoading();
    final storesResponse = await TestRepo.getStoresData();
     final List store = [];
     for (Map<String,dynamic>storeMap in  storesResponse['data']){
      final StoreModel store=  StoreModel.fromMap(storeMap);
        await _database.addStore(store);
     }

    final List? stores = await _database.getStores(); 
     print( stores!.length);

    final productsResponse = await TestRepo.getProductsData();
    for (Map<String,dynamic> productMap in productsResponse['data']){
        final ProductModel product = ProductModel.fromMap(productMap); 
        await _database.addProduct(product);
    }
    final List? products = await _database.getProducts();
    print(products!.length);

    final storesProductsRelationResponse = await TestRepo.getStoresProductsRelations();
    for (Map<String,dynamic> storeProductRelation in storesProductsRelationResponse['data']){
        await _database.addStoreProductRelation(
          storeProductRelation['store_id'],
          storeProductRelation['product_id']);
    }
    final List? storesProductsRelation = await _database.getStoresProductsRelations(); 
    print(storesProductsRelation!.length);
   
      
 

  }
  
}
  