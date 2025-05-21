import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stores_app/external/database/database_service.dart';
import 'package:stores_app/external/model/product_model.dart';
import 'package:stores_app/external/model/store_model.dart';
part 'single_shop_provider.g.dart';

@riverpod
class StoreDetails extends _$StoreDetails {
  @override
  Future<StoreModel> build(StoreModel store) async {
    return store;
  }

  Future<StoreModel> getAllProducts(StoreModel store) async {
    state = AsyncLoading();
    try {
      DatabaseService database = DatabaseService.instance;

      final List<ProductModel> products = await database.getStoreProducts(
        store.id,
      );
      store.products = products;
      state = AsyncData(store);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
    return store;
  }
}
