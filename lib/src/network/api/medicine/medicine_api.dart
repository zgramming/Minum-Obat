import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../utils/my_utils.dart';

class MedicineApi {
  final _dio = Dio();

  Future<Map<String, dynamic>> getMedicine(
    int? idUser, {
    int? idMedicine,
    int page = 1,
  }) async {
    final response = await _dio.get(
      '${constant.baseAPI}/medicine',
      queryParameters: {
        'id_user': '$idUser',
        if (idMedicine != null) 'id': '$idMedicine',
        'page': '$page',
      },
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
      ),
    );
    // log('json medicineCategory ${response.data}');
    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }

  Future<Map<String, dynamic>> addMedicine(Map<String, dynamic> data) async {
    final response = await _dio.post(
      '${constant.baseAPI}/medicine',
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

  Future<Map<String, dynamic>> updateMedicine(Map<String, dynamic> data) async {
    final response = await _dio.put(
      '${constant.baseAPI}/medicine',
      data: data,
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
      ),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }

  Future<Map<String, dynamic>> deleteMedicine(Map<String, dynamic> data) async {
    final response = await _dio.delete(
      '${constant.baseAPI}/medicine',
      data: data,
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    log('response ${response.data}');
    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }
}
