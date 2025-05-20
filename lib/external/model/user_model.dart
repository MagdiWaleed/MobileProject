import 'dart:convert';

class StudentModel {
  final String name;
  final String email;
  final String password;
  final int studentId;
  int? level;
  String? gender;
  String? profilePicPath;

  StudentModel({
    required this.name,
    required this.email,
    required this.password,
    required this.studentId,
    this.gender,
    this.level,
  });

  factory StudentModel.fromResponse(Map<String, dynamic> data) {
    StudentModel studentModel = StudentModel(
      name: data['name'],
      email: data['email'],
      password: data['password'],
      studentId: data['student_id'],
    );
    if (data['gender'] != null) {
      studentModel.gender = data['gender'] == 0 ? "Male" : "Female";
    }

    if (data['level'] != null) studentModel.level = int.parse(data['level']);

    if (data['profile_pic_path'] != null) {
      studentModel.profilePicPath = data['profile_pic_path'];
    }
    return studentModel;
  }

  static String updateRequest(
    String name,
    String email,
    String password,
    int studentId,
    int? level,
    int? gender,
    String profilePicPath,
  ) {
    final Map<String, dynamic> data = {
      "email": email,
      "name": name,
      "student_id": studentId,
      "password": password,
      "profile_pic_path": profilePicPath,
    };
    if (level != null) data['level'] = level;

    if (gender != null) data['gender'] = gender;

    final String request = json.encode(data);

    return request;
  }
}
