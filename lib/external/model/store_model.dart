import 'package:faker/faker.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/external/model/product_model.dart';

class StoreModel {
  final int id;
  final String name;
  final String storeDescription;
  final double review;
  final String image;
  final double storeLocationLongitude;
  final double storeLocationLatitude;
  List<ProductModel> products = [];

  StoreModel({
    required this.id,
    required this.name,
    required this.review,
    required this.image,
    required this.storeLocationLatitude,
    required this.storeLocationLongitude,
    required this.storeDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'store_id': id,
      'store_name': name,
      'store_review': review,
      'store_image': image.replaceFirst("${AppData.SERVER_URL!}/", ""),
      'store_location_longitude': storeLocationLongitude,
      'store_location_latitude': storeLocationLatitude,
      "store_description": storeDescription,
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> data) {
    return StoreModel(
      id: data['store_id'],
      name: data['store_name'],
      storeLocationLongitude: data['store_location_longitude'],
      storeLocationLatitude: data['store_location_latitude'],
      review: data['store_review'],
      image: "${AppData.SERVER_URL!}/${data['store_image']}",
      storeDescription: data["store_description"],
    );
  }
  static String getRandomImage() {
    return faker.image.loremPicsum();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
