import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stores_app/external/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreRepo {
  static Future<Map<String, dynamic>> getStoresData() async {
    final client = http.Client();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    try {
      var response = await client.get(
        Uri.parse('${AppData.SERVER_URL}/stores/'),
        headers: {"Content-Type": "application/json", 'Authorization': token!},
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
