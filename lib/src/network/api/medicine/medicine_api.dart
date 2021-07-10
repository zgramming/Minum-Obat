import 'package:dio/dio.dart';
import 'package:minum_obat/src/utils/my_utils.dart';

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
    final formData = FormData.fromMap(data);
    final response = await _dio.post(
      '${constant.baseAPI}/medicine',
      data: formData,
      options: Options(validateStatus: (status) => (status ?? 0) < 500),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    return json;
  }
}
