import 'dart:convert';

import 'package:flutter/foundation.dart';

class StudentModel {
  final String name;
  final String email;
  final String password;
  final int student_id;
  int? level;
  String? gender;
  String? profile_pic_path;

  StudentModel({
    required this.name,
    required this.email,
    required this.password,
    required this.student_id,
    this.gender,
    this.level,
  });

  factory StudentModel.fromResponse(Map<String, dynamic> data) {
    StudentModel studentModel = StudentModel(
      name: data['name'],
      email: data['email'],
      password: data['password'],
      student_id: data['student_id'],
    );
    if (data['gender'] != null)
      studentModel.gender = data['gender'] == 0 ? "Male" : "Female";

    if (data['level'] != null) studentModel.level = int.parse(data['level']);

    if (data['profile_pic_path'] != null)
      studentModel.profile_pic_path = data['profile_pic_path'];
    return studentModel;
  }

  static String signupRequest(
    String name,
    String email,
    String password,
    int student_id,
    int? level,
    int? gender,
  ) {
    final Map<String, dynamic> data = {
      "email": email,
      "name": name,
      "student_id": student_id,
      "password": password,
    };
    if (level != null) data['level'] = level;

    if (gender != null) data['gender'] = gender;
    final String request = json.encode(data);

    return request;
  }

  static String updateRequest(
    String name,
    String email,
    String password,
    int student_id,
    int? level,
    int? gender,
    String profile_pic_path,
  ) {
    final Map<String, dynamic> data = {
      "email": email,
      "name": name,
      "student_id": student_id,
      "password": password,
      "profile_pic_path": profile_pic_path,
    };
    if (level != null) data['level'] = level;

    if (gender != null) data['gender'] = gender;

    final String request = json.encode(data);

    return request;
  }

  static String loginRequest(String email, String password) {
    final Map<String, dynamic> data = {"email": email, "password": password};
    final String request = json.encode(data);

    return request;
  }
}
