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
    int? idMedicineSchedule,
  }) async {
    final result = await _medicineScheduleDetailApi.getMedicineScheduleDetail(
      id: id,
      idMedicineSchedule: idMedicineSchedule,
    );
    final list = result['data'] as List<dynamic>;
    final listScheduleDetail = List<MedicineScheduleDetailModel>.from(
        list.map((e) => MedicineScheduleDetailModel.fromJson(e as Map<String, dynamic>)).toList());
    state = [...listScheduleDetail];
    return {
      'message': result['message'] as String,
      'data': listScheduleDetail,
    };
  }

  Future<Map<String, dynamic>> post(
    int idMedicineSchedule, {
    SpecificDay specificDay = SpecificDay.daily,
  }) async {
    final result = await _medicineScheduleDetailApi.addMedicineScheduleDetail({
      'id_medicine_schedule': '$idMedicineSchedule',
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

final getMedicineScheduleDetail =
    FutureProvider.autoDispose.family<List<MedicineScheduleDetailModel>, int?>(
  (ref, idMedicineSchedule) async {
    final _medicineScheduleDetailProvider =
        ref.read(MedicineScheduleDetailProvider.provider.notifier);
    final result =
        await _medicineScheduleDetailProvider.get(idMedicineSchedule: idMedicineSchedule ?? 0);
    return result['data'] as List<MedicineScheduleDetailModel>;
  },
);
