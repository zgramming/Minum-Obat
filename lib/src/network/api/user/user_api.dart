import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../utils/my_utils.dart';

class UserApi {
  final _dio = Dio();

  Future<Map<String, dynamic>> registration(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    final response = await _dio.post(
      '${constant.baseAPI}/registration',
      data: formData,
      options: Options(validateStatus: (status) => (status ?? 0) < 500),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    final response = await _dio.post(
      '${constant.baseAPI}/login',
      data: formData,
      options: Options(validateStatus: (status) => (status ?? 0) < 500),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }

    return json;
  }

  Future<Map<String, dynamic>> updateImage(Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);
    final response = await _dio.post(
      '${constant.baseAPI}/updateImage',
      data: formData,
      options: Options(validateStatus: (status) => (status ?? 0) < 500),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    log('json $json');
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }

    return json;
  }

  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data) async {
    final response = await _dio.put(
      '${constant.baseAPI}/updatePassword',
      data: data,
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    log('json ${response.data}');
    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }

    return json;
  }
}
