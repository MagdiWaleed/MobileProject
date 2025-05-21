import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stores_app/external/database/database_service.dart';
import 'package:stores_app/external/model/product_model.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:stores_app/splash/repo/splash_repo.dart';
part 'splash_provider.g.dart';

@riverpod
class GetStoresDataSplash extends _$GetStoresDataSplash {
  final DatabaseService _database = DatabaseService.instance;
  @override
  FutureOr<dynamic> build() => [];

  Future<void> fetchStoresData() async {
    state = AsyncLoading();

    try {
      // Clear the database before adding new data
      await _database.deleteAll();
      final storesResponse = await SplashRepo.getStoresData();

      for (Map<String, dynamic> storeMap in storesResponse['data']) {
        final StoreModel store = StoreModel.fromMap(storeMap);
        await _database.addStore(store);
      }

      final productsResponse = await SplashRepo.getProductsData();
      for (Map<String, dynamic> productMap in productsResponse['data']) {
        final ProductModel product = ProductModel.fromMap(productMap);
        await _database.addProduct(product);
      }

      final storesProductsRelationResponse =
          await SplashRepo.getStoresProductsRelations();
      for (Map<String, dynamic> storeProductRelation
          in storesProductsRelationResponse['data']) {
        await _database.addStoreProductRelation(
          storeProductRelation['store_id'],
          storeProductRelation['product_id'],
        );
      }
      state = AsyncData("succes");
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
