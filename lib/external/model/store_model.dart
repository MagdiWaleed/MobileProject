import 'package:faker/faker.dart';
import 'package:stores_app/external/app_data.dart';
import 'package:stores_app/external/model/product_model.dart';

class StoreModel {
  final int id;
  final String name;
  final String store_description;
  final double review;
  final String image;
  final double store_location_longitude;
  final double store_location_latitude;
  final List<ProductModel> products;

  StoreModel({
    required this.id,
    required this.name,
    required this.review,
    required this.image,
    required this.store_location_latitude,
    required this.store_location_longitude,
    required this.store_description,
    this.products = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'store_id': id,
      'store_name': name,
      'store_review': review,
      'store_image': image.replaceFirst("${AppData.SERVER_URL!}/", ""),
      'store_location_longitude': store_location_longitude,
      'store_location_latitude': store_location_latitude,
      "store_description": store_description,
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> data) {
    return StoreModel(
      id: data['store_id'],
      name: data['store_name'],
      store_location_longitude: data['store_location_longitude'],
      store_location_latitude: data['store_location_latitude'],
      review: data['store_review'],
      image: AppData.SERVER_URL! + "/" + data['store_image'],
      store_description: data["store_description"],
    );
  }
  static String getRandomImage() {
    return faker.image.image(random: true);
  }
}
