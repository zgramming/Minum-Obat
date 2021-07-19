import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../utils/my_utils.dart';

class MedicineScheduleDetailApi {
  final _dio = Dio();

  Future<Map<String, dynamic>> getMedicineScheduleDetail({
    int? id,
    int? idMedicineSchedule,
  }) async {
    final response = await _dio.get(
      '${constant.baseAPI}/medicineScheduleDetail',
      queryParameters: {
        if (id == null) 'id_medicine': '$idMedicineSchedule' else 'id': '$id',
      },
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
      ),
    );
    log('json medicine scheduledetial ${response.data}');
    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }

  Future<Map<String, dynamic>> addMedicineScheduleDetail(Map<String, dynamic> data) async {
    final response = await _dio.post(
      '${constant.baseAPI}/medicineScheduleDetail',
      data: data,
      options: Options(validateStatus: (status) => (status ?? 0) < 500),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }
}
