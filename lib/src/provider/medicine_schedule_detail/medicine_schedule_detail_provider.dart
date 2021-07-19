import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/my_network.dart';

class MedicineScheduleDetailProvider extends StateNotifier<List<MedicineScheduleDetailModel>> {
  MedicineScheduleDetailProvider() : super([]);
  final _medicineScheduleDetailApi = MedicineScheduleDetailApi();
  static final provider =
      StateNotifierProvider<MedicineScheduleDetailProvider, List<MedicineScheduleDetailModel>>(
          (ref) => MedicineScheduleDetailProvider());

  Future<Map<String, dynamic>> get({
    int? id,
    int? idMedicine,
  }) async {
    final result = await _medicineScheduleDetailApi.getMedicineScheduleDetail(
      id: id,
      idMedicineSchedule: idMedicine,
    );

    final list = result['data'] as List<dynamic>;
    final listScheduleDetail = List<MedicineScheduleDetailModel>.from(
        list.map((e) => MedicineScheduleDetailModel.fromJson(e as Map<String, dynamic>)).toList());
    log('before ${state.length}');
    state = [...state, ...listScheduleDetail];
    log('after ${state.length}');
    return {
      'message': result['message'] as String,
      'data': listScheduleDetail,
    };
  }

  Future<Map<String, dynamic>> post(
    int idMedicine, {
    SpecificDay specificDay = SpecificDay.daily,
  }) async {
    final result = await _medicineScheduleDetailApi.addMedicineScheduleDetail({
      'id_medicine': '$idMedicine',
      'specific_day': specificDay,
    });

    final model = MedicineScheduleDetailModel.fromJson(result['data'] as Map<String, dynamic>);
    state = [...state, model];

    return {
      'message': result['message'] as String,
      'data': '$model',
    };
  }
}

final getMedicineScheduleDetail = FutureProvider.family<List<MedicineScheduleDetailModel>, int?>(
  (ref, idMedicine) async {
    final _medicineScheduleDetailProvider =
        ref.read(MedicineScheduleDetailProvider.provider.notifier);
    final result = await _medicineScheduleDetailProvider.get(idMedicine: idMedicine ?? 0);
    return result['data'] as List<MedicineScheduleDetailModel>;
  },
);

final medicineScheduleDetailByIdMedicine =
    StateProvider.family<List<MedicineScheduleDetailModel>, int>((ref, idMedicine) {
  final _medicinesScheduleDetail = ref.watch(MedicineScheduleDetailProvider.provider);
  return _medicinesScheduleDetail.where((element) => element.medicine?.id == idMedicine).toList();
});
