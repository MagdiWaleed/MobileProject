import 'package:stores_app/external/app_data.dart';

class ProductModel {
  final String name;
  final String descrption;
  final int id;
  final String image;
  final double price;

  ProductModel({
    required this.name,
    required this.descrption,
    required this.id,
    required this.image,
    required this.price,
  });
  factory ProductModel.fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data['product_id'],
      name: data["product_name"],

      image: AppData.SERVER_URL! + data['product_image'],
      descrption: data['product_description'],
      price: data['product_price'],
    );
  }
}
