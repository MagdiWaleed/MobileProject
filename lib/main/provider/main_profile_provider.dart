import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/main/services/main_profile_service/repo/main_profile_repo.dart';
import 'package:stores_app/external/model/user_model.dart';

final studentProfileProvider = FutureProvider<StudentModel>((ref) async {
  final response = await MainProfileRepo.getStudentData();

  if (response['status']) {
    return StudentModel.fromResponse(response);
  } else {
    throw Exception(response['error'] ?? 'Unknown error occurred');
  }
});
