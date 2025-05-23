import 'package:stores_app/external/model/product_model.dart';
import 'package:stores_app/external/model/store_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _storesTableName = "stores";
  final String _storesIdColumnName = "store_id";
  final String _storesNameColumnName = "store_name";
  final String _storesReviewColumnName = "store_review";
  final String _storesImageColumnName = "store_image";
  final String _storeLongitudeColumnName = "store_location_longitude";
  final String _storeLatitudeColumnName = "store_location_latitude";
  final String _storeDescriptionColumnName = "store_description";

  final String _productsTableName = "products";
  final String _productsIdColumnName = "product_id";
  final String _productsNameColumnName = "product_name";
  final String _productsPriceColumnName = "product_price";
  final String _productsImageColumnName = "product_image";
  final String _productsDescriptionColumnName = "product_description";

  final String _storesProductsRelationTableName = "storesProductRelation";
  final String _storesProductsRelationIdColumnName = "id";
  final String _storesProductsRelationStoreIdColumnName = "storeid";
  final String _storesProductsRelationProductIdColumnName = "productid";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirpath = await getDatabasesPath();
    final databasePath = join(databaseDirpath, "stores_db.db");

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_storesTableName (
          $_storesIdColumnName INTEGER NOT NULL,
          $_storesNameColumnName TEXT NOT NULL,
          $_storesImageColumnName TEXT NOT NULL,
          $_storesReviewColumnName REAL NOT NULL,
          $_storeLongitudeColumnName REAL NOT NULL,
          $_storeLatitudeColumnName REAL NOT NULL,
          $_storeDescriptionColumnName TEXT NOT NULL
        );
      ''');

        await db.execute('''
        CREATE TABLE $_productsTableName (
          $_productsIdColumnName INTEGER NOT NULL,
          $_productsNameColumnName TEXT NOT NULL,
          $_productsImageColumnName TEXT NOT NULL,
          $_productsPriceColumnName REAL NOT NULL,
          $_productsDescriptionColumnName TEXT NOT NULL
        );
      ''');

        await db.execute('''
        CREATE TABLE $_storesProductsRelationTableName (
          $_storesProductsRelationIdColumnName INTEGER PRIMARY KEY,
          $_storesProductsRelationStoreIdColumnName INTEGER NOT NULL,
          $_storesProductsRelationProductIdColumnName INTEGER NOT NULL
        );
      ''');
      },
    );

    return database;
  }

  Future<bool> addStore(StoreModel store) async {
    final isExist = await getStoreById(store.id);
    if (isExist == null) {
      final storeMap = store.toMap();
      final db = await database;
      await db.insert(_storesTableName, {
        _storesIdColumnName: storeMap['store_id'],
        _storesNameColumnName: storeMap['store_name'],
        _storeLatitudeColumnName: storeMap['store_location_latitude'],
        _storeDescriptionColumnName: storeMap['store_description'],
        _storeLongitudeColumnName: storeMap['store_location_longitude'],
        _storesImageColumnName: storeMap['store_image'],
        _storesReviewColumnName: storeMap['store_review'],
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addProduct(ProductModel product) async {
    final isExist = await getProductById(product.id);
    if (isExist == null) {
      final db = await database;
      await db.insert(_productsTableName, {
        _productsIdColumnName: product.id,
        _productsNameColumnName: product.name,
        _productsDescriptionColumnName: product.descrption,
        _productsImageColumnName: product.image,
        _productsPriceColumnName: product.price,
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addStoreProductRelation(int storeid, int productid) async {
    final isExist = await getStoreProductRelation(storeid, productid);
    if (isExist == null) {
      final db = await database;
      await db.insert(_storesProductsRelationTableName, {
        _storesProductsRelationStoreIdColumnName: storeid,
        _storesProductsRelationProductIdColumnName: productid,
      });
      return true;
    } else {
      return false;
    }
  }

  Future<StoreModel?> getStoreById(int id) async {
    final db = await database;
    final data = await db.query(
      _storesTableName,
      where: '$_storesIdColumnName = ?',
      whereArgs: [id],
    );

    if (data.isNotEmpty) {
      return StoreModel.fromMap(data.first);
    } else {
      return null;
    }
  }

  Future<ProductModel?> getProductById(int id) async {
    final db = await database;
    final data = await db.query(
      _productsTableName,
      where: '$_productsIdColumnName = ?',
      whereArgs: [id],
    );

    if (data.isNotEmpty) {
      return ProductModel.fromMap(data.first);
    } else {
      return null;
    }
  }

  Future<Map?> getStoreProductRelation(int storeid, int productid) async {
    final db = await database;
    final data = await db.query(
      _storesProductsRelationTableName,
      where:
          '$_storesProductsRelationStoreIdColumnName = ? AND $_storesProductsRelationProductIdColumnName = ?',
      whereArgs: [storeid, productid],
    );

    if (data.isNotEmpty) {
      return data.first;
    } else {
      return null;
    }
  }

  Future<List<ProductModel>> getStoreProducts(int storeId) async {
    final db = await database;

    final List<Map<String, dynamic>> data = await db.rawQuery(
      '''
    SELECT p.*
    FROM $_productsTableName p
    JOIN $_storesProductsRelationTableName spr
    ON p.$_productsIdColumnName = spr.$_storesProductsRelationProductIdColumnName
    WHERE spr.$_storesProductsRelationStoreIdColumnName = ?
  ''',
      [storeId],
    );
    return data.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<List<StoreModel>?> getStores() async {
    try {
      final db = await database;
      final data = await db.query(_storesTableName);
      List<StoreModel> stores = data.map((e) => StoreModel.fromMap(e)).toList();
      return stores;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map>?> getStoresProductsRelations() async {
    try {
      final db = await database;
      final data = await db.query(_storesProductsRelationTableName);
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductModel>?> getProducts() async {
    try {
      final db = await database;
      final data = await db.query(_productsTableName);
      List<ProductModel> products =
          data.map((e) => ProductModel.fromMap(e)).toList();
      return products;
    } catch (e) {
      return null;
    }
  }

  Future<List<StoreModel>> getStoresAndProductsMatching(
    String searchString,
  ) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT s.*, p.*
    FROM $_storesTableName s
    JOIN $_storesProductsRelationTableName spr ON s.$_storesIdColumnName = spr.$_storesProductsRelationStoreIdColumnName
    JOIN $_productsTableName p ON p.$_productsIdColumnName = spr.$_storesProductsRelationProductIdColumnName
    WHERE LOWER(p.$_productsNameColumnName) LIKE ? or LOWER(s.$_storesNameColumnName) LIKE ?
  ''',
      ['%${searchString.toLowerCase()}%', '%${searchString.toLowerCase()}%'],
    );

    final List<StoreModel> stores = [];
    for (var row in result) {
      final StoreModel store = StoreModel.fromMap(row);
      if (stores.contains(store)) {
        int index = stores.indexWhere(
          (singleStore) => singleStore.id == store.id,
        );
        stores[index].products.add(ProductModel.fromMap(row));
        continue;
      } else {
        store.products.add(ProductModel.fromMap(row));
        stores.add(store);
      }
    }

    return stores;
  }

  Future<List<StoreModel>> getStoresProductsMatching(String productName) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT s.*, p.*
    FROM $_storesTableName s
    JOIN $_storesProductsRelationTableName spr ON s.$_storesIdColumnName = spr.$_storesProductsRelationStoreIdColumnName
    JOIN $_productsTableName p ON p.$_productsIdColumnName = spr.$_storesProductsRelationProductIdColumnName
    WHERE LOWER(p.$_productsNameColumnName) LIKE ?
  ''',
      ['%${productName.toLowerCase()}%'],
    );

    final List<StoreModel> stores = [];
    for (var row in result) {
      final StoreModel store = StoreModel.fromMap(row);
      if (stores.contains(store)) {
        int index = stores.indexWhere(
          (singleStore) => singleStore.id == store.id,
        );
        stores[index].products.add(ProductModel.fromMap(row));
        continue;
      } else {
        store.products.add(ProductModel.fromMap(row));
        stores.add(store);
      }
    }

    return stores;
  }

  Future<bool> deleteStore(int id) async {
    final db = await database;
    await db.delete(
      _storesTableName,
      where: '$_storesIdColumnName = ?',
      whereArgs: [id],
    );
    return true;
  }

  Future<void> deleteAllProducts() async {
    final db = await database;
    await db.delete(_productsTableName);
  }

  Future<void> deleteAllStoresProductsRelations() async {
    final db = await database;
    await db.delete(_storesProductsRelationTableName);
  }

  Future<void> deleteAllStores() async {
    final db = await database;
    await db.delete(_storesTableName);
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(_storesTableName);
    await db.delete(_productsTableName);
    await db.delete(_storesProductsRelationTableName);
  }
}
