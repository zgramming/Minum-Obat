import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/my_network.dart';

class MedicineScheduleProvider extends StateNotifier<List<MedicineScheduleModel>> {
  MedicineScheduleProvider() : super([]);

  final _medicineScheduleApi = MedicineScheduleApi();

  static final provider =
      StateNotifierProvider<MedicineScheduleProvider, List<MedicineScheduleModel>>(
          (ref) => MedicineScheduleProvider());

  Future<List<MedicineScheduleModel>> get({
    int? id,
    int? idMedicine,
  }) async {
    final result = await _medicineScheduleApi.getMedicineSchedule(
      idMedicine: idMedicine,
      id: id,
    );

    final list = result['data'] as List<dynamic>;
    final listSchedule = List<MedicineScheduleModel>.from(
        list.map((e) => MedicineScheduleModel.fromJson(e as Map<String, dynamic>)).toList());
    state = [...state, ...listSchedule];
    return listSchedule;
  }

  Future<Map<String, dynamic>> post({
    required int idMedicine,
    required String startSchedule,
    required String endSchedule,
  }) async {
    final result = await _medicineScheduleApi.addMedicineSchedule({
      'id_medicine': '$idMedicine',
      'start_schedule': startSchedule,
      'end_schedule': endSchedule,
    });

    // log('result provider medicineschedulePost ${result['data']}');

    final data = result['data'] as Map<String, dynamic>;

    final medicineSchedule = MedicineScheduleModel.fromJson(data);

    state = [...state, medicineSchedule];
    return {
      'message': result['message'] as String,
      'medicineSchedule': medicineSchedule,
    };
  }

  Future<Map<String, dynamic>> update({
    required int id,
    required String startSchedule,
    required String endSchedule,
  }) async {
    final result = await _medicineScheduleApi.updateMedicineSchedule({
      'id': '$id',
      'start_schedule': startSchedule,
      'end_schedule': endSchedule,
    });
    final medicineSchedule = MedicineScheduleModel.fromJson(result['data'] as Map<String, dynamic>);
    state = [
      for (var item in state)
        if (item.id == id)
          item.copyWith(startSchedule: startSchedule, endSchedule: endSchedule)
        else
          item
    ];

    return {
      'message': result['message'] as String,
      'data': medicineSchedule,
    };
  }

  Future<Map<String, dynamic>> delete({required int id}) async {
    final result = await _medicineScheduleApi.deleteMedicineSchedule({
      'id': '$id',
    });

    state = [...state.where((element) => element.id != id).toList()];
    return result;
  }

  void deleteByIdMedicine({required int idMedicine}) {
    log('MedicineSchedule before delete ${state.length}');
    // state = [...state.where((element) => element.medicine.id != idMedicine).toList()];
    log('MedicineSchedule after delete ${state.length}');
  }
}

final getMedicineSchedule =
    FutureProvider.family<List<MedicineScheduleModel>, int>((ref, idMedicine) async {
  final _medicineScheduleProvider = ref.read(MedicineScheduleProvider.provider.notifier);
  final result = await _medicineScheduleProvider.get(idMedicine: idMedicine);
  return result;
});

final medicineScheduleByIdMedicine =
    StateProvider.autoDispose.family<List<MedicineScheduleModel>, int>((ref, idMedicine) {
  final provider = ref.watch(MedicineScheduleProvider.provider);
  return provider.where((element) => element.medicine?.id == idMedicine).toList();
});
