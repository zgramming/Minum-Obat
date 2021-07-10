import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/my_network.dart';

class MedicineCategoryProvider extends StateNotifier<List<MedicineCategoryModel>> {
  final _medicineCategoryApi = MedicineCategoryApi();

  MedicineCategoryProvider() : super([]);

  Future<List<MedicineCategoryModel>> getMedicineCategory() async {
    final result = await _medicineCategoryApi.getMedicineCategory();

    log('state loaded $result');
    final list = result['data'] as List<dynamic>;
    final listMedicineCategory = List<MedicineCategoryModel>.from(
        list.map((e) => MedicineCategoryModel.fromJson(e as Map<String, dynamic>)).toList());

    state = [...listMedicineCategory];
    return listMedicineCategory;
  }
}

final medicineCategoryProvider =
    StateNotifierProvider<MedicineCategoryProvider, List<MedicineCategoryModel>>(
        (ref) => MedicineCategoryProvider());

final getMedicineCategory = FutureProvider<List<MedicineCategoryModel>>((ref) async {
  // log('loaded medicine category');
  final result = await ref.read(medicineCategoryProvider.notifier).getMedicineCategory();
  return result;
});

final medicineCategoryById =
    StateProvider.autoDispose.family<MedicineCategoryModel?, int>((ref, idCategory) {
  final list = ref.watch(medicineCategoryProvider);
  return list.firstWhereOrNull((element) => element.id == idCategory);
});

final totalMedicineCategory =
    StateProvider.autoDispose<int>((ref) => ref.watch(medicineCategoryProvider).length);
