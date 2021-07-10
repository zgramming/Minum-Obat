import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../utils/my_utils.dart';

class MedicineCategoryApi {
  final _dio = Dio();

  Future<Map<String, dynamic>> getMedicineCategory({int? idCategory}) async {
    final response = await _dio.get(
      '${constant.baseAPI}/medicineCategory',
      queryParameters: (idCategory == null) ? null : {'id': '$idCategory'},
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
}
