import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';
import '../../../utils/my_utils.dart';

class FormMedicineAppbar extends StatelessWidget implements PreferredSizeWidget {
  final MedicineCategoryModel? selectedMedicineCategory;
  final TypeSchedule? selectedTypeSchedule;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;

  const FormMedicineAppbar({
    Key? key,
    required this.selectedMedicineCategory,
    required this.selectedTypeSchedule,
    required this.nameController,
    required this.descriptionController,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          FeatherIcons.arrowLeft,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Form Obat',
        style: fontsMontserratAlternate.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final medicineDetail = ref.watch(MedicineDetailProvider.provider);
            return IconButton(
              onPressed: () async {
                final validate = formKey.currentState?.validate() ?? false;
                if (!validate) {
                  return;
                }

                Map<String, dynamic> result = {};
                try {
                  ref.read(isLoading).state = true;
                  final idMedicineCategory = selectedMedicineCategory?.id;
                  final typeSchedule = selectedTypeSchedule;
                  final listScheduleDay = ref.read(selectedDay).state;

                  if (idMedicineCategory == null) {
                    throw Exception('Kategori obat tidak boleh kosong');
                  }
                  if (typeSchedule == null) {
                    throw Exception('Tipe Jadwal minum obat tidak boleh kosong');
                  }

                  final user = ref.read(sessionLogin).state;
                  if (medicineDetail == null) {
                    if (typeSchedule == TypeSchedule.weekly && listScheduleDay.isEmpty) {
                      throw Exception('Minimal pilih salah satu hari jika memilih jadwal mingguan');
                    }
                    result = await ref.read(MedicineProvider.provider.notifier).add(
                          idMedicineCategory: idMedicineCategory,
                          idUser: user?.id ?? 0,
                          name: nameController.text,
                          description: descriptionController.text,
                          typeSchedule: typeSchedule,
                          listScheduleDay: listScheduleDay,
                        );
                  } else {
                    log('$selectedMedicineCategory');
                    result = await ref.read(MedicineProvider.provider.notifier).update(
                          medicineDetail.id ?? 0,
                          medicineCategory: selectedMedicineCategory,
                          user: user,
                          name: nameController.text,
                          description: descriptionController.text,
                          typeSchedule: typeSchedule,
                        );
                  }
                  ref
                      .read(MedicineDetailProvider.provider.notifier)
                      .setMedicine(result['medicine'] as MedicineModel);
                  GlobalFunction.showSnackBar(
                    context,
                    content: Text(result['message'] as String),
                    snackBarType: SnackBarType.success,
                  );
                  // _resetForm();
                  ref.read(isLoading).state = false;
                } catch (e) {
                  ref.read(isLoading).state = false;
                  log(e.toString());
                  GlobalFunction.showSnackBar(
                    context,
                    content: Text(e.toString()),
                    snackBarType: SnackBarType.error,
                  );
                }
              },
              icon: const Icon(
                FeatherIcons.save,
                color: Colors.white,
              ),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }
}
