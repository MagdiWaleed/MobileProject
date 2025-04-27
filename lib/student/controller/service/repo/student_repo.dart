import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stores_app/external/app_data.dart';

class StudentRepo {
  static Future<Map<String, dynamic>> signup(
    Map<String, dynamic> studentData,
  ) async {
    final client = http.Client();

    try {
      var response = await client.post(
        Uri.parse('${AppData.SERVER_URL}/signup/'),
        body: json.encode(studentData),
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return {"status": true, 'message': data['message']};
      } else {
        return {'status': false, "error": data['error']};
      }
    } catch (e) {
      return {'status': false, "error": e};
    }
  }

  static Future<Map<String, dynamic>> updateStudentData(
    Map<String, dynamic> studentData,
  ) async {
    final client = http.Client();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    print(token);

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${AppData.SERVER_URL}/updatestudentdata/'),
      );
      if (studentData['profile_pic_path'] != "DEFAULT_PROFILE_IMAGE.png" &&
          studentData['profile_pic_path'] != "#" &&
          studentData['profile_pic_path'] != "DELETE")
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_pic_path',
            studentData['profile_pic_path'],
          ),
        );

      request.headers['Authorization'] = token!;

      request.fields['data'] = json.encode(studentData);

      var response = await request.send();
      final Map<String, dynamic> data = json.decode(
        await response.stream.bytesToString(),
      );
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

  static Future<Map<String, dynamic>> login(
    Map<String, dynamic> studentData,
  ) async {
    final client = http.Client();

    try {
      var response = await client.post(
        Uri.parse('${AppData.SERVER_URL}/login/'),
        body: json.encode(studentData),
        headers: {"Content-Type": "application/json"},
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return {"status": true, 'message': data['message']};
      } else {
        return {'status': false, "error": data['error']};
      }
    } catch (e) {
      return {'status': false, "error": e};
    }
  }
}
