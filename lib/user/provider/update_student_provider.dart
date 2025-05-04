import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stores_app/user/repo/student_repo.dart';

final updateStudentProvider =
    FutureProvider.family<String, Map<String, dynamic>>((
      ref,
      studentData,
    ) async {
      final response = await StudentRepo.updateStudentData(studentData);
      if (response['status']) {
        return response['message'] ?? 'Updated Successfully';
      } else {
        throw Exception(response['error'] ?? 'Failed to update student data');
      }
    });
