import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../utils/my_utils.dart';

class MedicineScheduleApi {
  final _dio = Dio();

  Future<Map<String, dynamic>> getMedicineSchedule({int? id, int? idMedicine}) async {
    final response = await _dio.get(
      '${constant.baseAPI}/medicineSchedule',
      queryParameters: {
        if (id == null) 'id_medicine': '$idMedicine' else 'id': '$id',
      },
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
      ),
    );
    // log('json medicineSchedule ${response.data['data']} $id || $idMedicine');
    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }

  Future<Map<String, dynamic>> addMedicineSchedule(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    final response = await _dio.post(
      '${constant.baseAPI}/medicineSchedule',
      data: formData,
      options: Options(validateStatus: (status) => (status ?? 0) < 500),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }

  Future<Map<String, dynamic>> updateMedicineSchedule(Map<String, dynamic> data) async {
    final response = await _dio.put(
      '${constant.baseAPI}/medicineSchedule',
      data: data,
      options: Options(validateStatus: (status) => (status ?? 0) < 500),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }

  Future<Map<String, dynamic>> deleteMedicineSchedule(Map<String, dynamic> data) async {
    final response = await _dio.delete(
      '${constant.baseAPI}/medicineSchedule',
      data: data,
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }
}
