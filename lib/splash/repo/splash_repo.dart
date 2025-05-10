import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stores_app/external/app_data.dart';

class SplashRepo {
  static Future<Map<String, dynamic>> getStoresData() async {
    final client = http.Client();
    try {
      var response = await client.get(
        Uri.parse('${AppData.SERVER_URL}/stores/'),
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        data["status"] = true;
        return data;
      } else {
        data["status"] = false;
        return data;
      }
    } catch (e) {
      return {'status': false, "error": e};
    }
  }

  static Future<Map<String, dynamic>> getProductsData() async {
    final client = http.Client();
    try {
      var response = await client.get(
        Uri.parse('${AppData.SERVER_URL}/items/'),
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        data["status"] = true;
        return data;
      } else {
        data["status"] = false;
        return data;
      }
    } catch (e) {
      return {'status': false, "error": e};
    }
  }

  static Future<Map<String, dynamic>> getStoresProductsRelations() async {
    final client = http.Client();
    try {
      var response = await client.get(
        Uri.parse('${AppData.SERVER_URL}/stores_items/'),
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        data["status"] = true;
        return data;
      } else {
        data["status"] = false;
        return data;
      }
    } catch (e) {
      return {'status': false, "error": e};
    }
  }
}
