import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/my_network.dart';
import '../../screen/form_medicine/widgets/form_medicine_detail.dart';
import '../my_provider.dart';

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

  final _medicineScheduleProvider = MedicineScheduleProvider();

  final _medicineScheduleDetailProvider = MedicineScheduleDetailProvider();

  static final provider =
      StateNotifierProvider<MedicineProvider, List<MedicineModel>>((ref) => MedicineProvider());

  Future<List<MedicineModel>> get(
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

  Future<Map<String, dynamic>> add({
    required int idMedicineCategory,
    required int idUser,
    required String name,
    required String description,
    required TypeSchedule typeSchedule,
    required List<ScheduleDay> listScheduleDay,
  }) async {
    final days = listScheduleDay.map((e) => e.value).toList();
    final result = await _medicineApi.addMedicine({
      'id_medicine_category': '$idMedicineCategory',
      'id_user': '$idUser',
      'name': name,
      'description': description,
      'type_schedule': TypeScheduleValues[typeSchedule],
      'specific_day[]': days,
    });

    final medicine = MedicineModel.fromJson(result['data'] as Map<String, dynamic>);

    /// After insert Medicine, get schedule detail
    await _medicineScheduleDetailProvider.get(idMedicine: medicine.id);
    state = [...state, medicine];

    return {
      'message': result['message'] as String,
      'medicine': medicine,
    };
  }

  Future<Map<String, dynamic>> update(
    int id, {
    MedicineCategoryModel? medicineCategory,
    UserModel? user,
    required String name,
    required String description,
    required TypeSchedule typeSchedule,
  }) async {
    final result = await _medicineApi.updateMedicine({
      'id': '$id',
      'id_medicine_category': '${medicineCategory?.id}',
      'id_user': '${user?.id}',
      'name': name,
      'description': description,
      'type_schedule': TypeScheduleValues[typeSchedule],
    });

    final medicine = MedicineModel.fromJson(result['data'] as Map<String, dynamic>);

    state = [
      for (var item in state)
        if (item.id == id)
          item.copyWith(
            medicineCategory: medicineCategory,
            user: user,
            name: name,
            description: description,
            typeSchedule: typeSchedule,
          )
        else
          item
    ];

    return {
      'message': result['message'] as String,
      'medicine': medicine,
    };
  }

  Future<Map<String, dynamic>> delete({required int id}) async {
    final result = await _medicineApi.deleteMedicine({
      'id': '$id',
    });

    _medicineScheduleProvider.deleteByIdMedicine(idMedicine: id);
    state = [...state.where((element) => element.id != id).toList()];

    return result;
  }
}

/// Initialize Table [Medicine,MedicineSchedule,MedicineScheduleDetail]
final getMedicine = FutureProvider<List<MedicineModel>>((ref) async {
  final idUser = ref.read(sessionLogin).state?.id ?? 0;
  final medicines =
      await ref.read(MedicineProvider.provider.notifier).get(idUser, clearCache: true);
  for (final medicine in medicines) {
    await ref.read(getMedicineSchedule(medicine.id ?? 0).future);
    await ref.read(getMedicineScheduleDetail(medicine.id ?? 0).future);
  }
  return medicines;
});

final medicineLoadMore = FutureProvider.family<List<MedicineModel>, int>((ref, page) async {
  final idUser = ref.read(sessionLogin).state?.id ?? 0;
  final medicines = await ref.read(MedicineProvider.provider.notifier).get(idUser, page: page);

  for (final medicine in medicines) {
    await ref.read(getMedicineSchedule(medicine.id ?? 0).future);
    await ref.read(getMedicineScheduleDetail(medicine.id ?? 0).future);
  }
  return medicines;
});

final medicineById = StateProvider.autoDispose.family<MedicineModel?, int>((ref, idMedicine) {
  final _medicineProvider = ref.watch(MedicineProvider.provider);
  return _medicineProvider.firstWhereOrNull((element) => element.id == idMedicine);
});

final medicineTabbarDistinct = StateProvider<List<TypeSchedule>>((ref) {
  final medicine = ref.watch(MedicineProvider.provider);
  final typeSchedule = medicine.map((e) => e.typeSchedule).toSet().toList()
    ..sort((a, b) => a.index.compareTo(b.index));
  return typeSchedule;
});

final medicineBySchedule =
    StateProvider.autoDispose.family<List<MedicineModel>, TypeSchedule>((ref, typeSchedule) {
  final medicine = ref.watch(MedicineProvider.provider);
  return medicine.where((element) => element.typeSchedule == typeSchedule).toList();
});
