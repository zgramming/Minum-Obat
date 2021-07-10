import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:minum_obat/src/provider/my_provider.dart';
import '../../network/my_network.dart';

class MedicineDetailProvider extends StateNotifier<MedicineModel?> {
  MedicineDetailProvider() : super(null);

  void setMedicine(MedicineModel model) {
    final result = model;
    state = result;
  }

  static final provider = StateNotifierProvider.autoDispose<MedicineDetailProvider, MedicineModel?>(
      (ref) => MedicineDetailProvider());
}

class MedicineProvider extends StateNotifier<List<MedicineModel>> {
  MedicineProvider() : super([]);

  final _medicineApi = MedicineApi();

  Future<List<MedicineModel>> getMedicine(
    int? idUser, {
    int? idMedicine,
    int page = 1,
    bool clearCache = false,
  }) async {
    final result = await _medicineApi.getMedicine(
      idUser,
      idMedicine: idMedicine,
      page: page,
    );

    final list = result['data'] as List<dynamic>;
    final listMedicine = List<MedicineModel>.from(
        list.map((e) => MedicineModel.fromJson(e as Map<String, dynamic>)).toList());

    state = [
      if (!clearCache) ...state,
      ...listMedicine,
    ];
    return listMedicine;
  }

  Future<Map<String, dynamic>> addMedicine({
    required int idMedicineCategory,
    required int idUser,
    required String name,
    required String description,
    required TypeSchedule typeSchedule,
  }) async {
    final result = await _medicineApi.addMedicine({
      'id_medicine_category': '$idMedicineCategory',
      'id_user': '$idUser',
      'name': name,
      'description': description,
      'type_schedule': typeSchedule == TypeSchedule.daily ? 'daily' : 'weekly',
    });

    final medicine = MedicineModel.fromJson(result['data'] as Map<String, dynamic>);

    state = [...state, medicine];

    return {
      'message': result['message'] as String,
      'medicine': medicine,
    };
  }
}

final medicineProvider =
    StateNotifierProvider<MedicineProvider, List<MedicineModel>>((ref) => MedicineProvider());

final getMedicine = FutureProvider<List<MedicineModel>>((ref) async {
  final idUser = ref.read(sessionLogin).state?.id ?? 0;
  final result = await ref.read(medicineProvider.notifier).getMedicine(idUser, clearCache: true);
  return result;
});

final medicineLoadMore = FutureProvider.family<List<MedicineModel>, int>((ref, page) async {
  final idUser = ref.read(sessionLogin).state?.id ?? 0;
  final result = await ref.read(medicineProvider.notifier).getMedicine(idUser, page: page);
  log('result LoadmoreMedicine ${result.length}');
  return result;
});

final medicineById = StateProvider.autoDispose.family<MedicineModel?, int>((ref, idMedicine) {
  final _medicineProvider = ref.watch(medicineProvider);
  return _medicineProvider.firstWhereOrNull((element) => element.id == idMedicine);
});

final medicineTabbarDistinct = StateProvider.autoDispose((ref) {
  final medicine = ref.watch(medicineProvider);
  final typeSchedule = medicine.map((e) => e.typeSchedule).toSet().toList()
    ..sort((a, b) => a.index.compareTo(b.index));
  return typeSchedule;
});

final medicineBySchedule =
    StateProvider.autoDispose.family<List<MedicineModel>, TypeSchedule>((ref, typeSchedule) {
  final medicine = ref.watch(medicineProvider);
  return medicine.where((element) => element.typeSchedule == typeSchedule).toList();
});
