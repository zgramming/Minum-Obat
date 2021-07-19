import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';
import '../../../utils/my_utils.dart';

class FormMedicineDetail extends StatelessWidget {
  final MedicineCategoryModel? selectedMedicineCategory;
  final TypeSchedule? selectedTypeSchedule;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;

  final void Function(MedicineCategoryModel? medicineCategory) onChangedMedicineCategory;
  final void Function(TypeSchedule? typeSchedule) onChangedTypeSchedule;

  const FormMedicineDetail({
    Key? key,
    required this.selectedMedicineCategory,
    required this.selectedTypeSchedule,
    required this.nameController,
    required this.descriptionController,
    required this.formKey,
    required this.onChangedMedicineCategory,
    required this.onChangedTypeSchedule,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormFieldCustom(
                controller: nameController,
                disableOutlineBorder: false,
                hintText: 'Obat Sakit Perut, Obat Penurun Panas',
                labelText: 'Nama Obat',
                validator: (value) => GlobalFunction.validateIsEmpty(value),
              ),
              const SizedBox(height: 20.0),
              Consumer(
                builder: (context, ref, child) {
                  final categories = ref.watch(medicineCategoryProvider);
                  return DropdownFormFieldCustom<MedicineCategoryModel>(
                    items: categories,
                    itemBuilder: (item) => Text(item?.name ?? ''),
                    selectedItem: selectedMedicineCategory,
                    onChanged: (value) => onChangedMedicineCategory(value),
                    labelText: 'Kategori',
                  );
                },
              ),
              const SizedBox(height: 20.0),
              TextFormFieldCustom(
                controller: descriptionController,
                disableOutlineBorder: false,
                hintText: 'Keterangan obat',
                labelText: 'Keterangan',
                minLines: 3,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                validator: (value) => GlobalFunction.validateIsEmpty(value),
              ),
              const SizedBox(height: 20.0),
              Consumer(
                builder: (context, ref, child) {
                  return DropdownFormFieldCustom<TypeSchedule>(
                    items: const [
                      TypeSchedule.daily,
                      TypeSchedule.weekly,
                    ],
                    itemBuilder: (item) => Text(item == TypeSchedule.daily ? "Harian" : "Mingguan"),
                    selectedItem: selectedTypeSchedule,
                    onChanged: (value) => onChangedTypeSchedule(value),
                    labelText: 'Tipe Jadwal',
                  );
                },
              ),
              const SizedBox(height: 20.0),
              if (selectedTypeSchedule == TypeSchedule.weekly) ...[
                Consumer(
                  builder: (context, ref, child) => Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: listScheduleDay.map(
                      (e) {
                        final isExists = ref
                            .watch(selectedDay)
                            .state
                            .firstWhereOrNull((element) => element.value == e.value);

                        return InkWell(
                          onTap: () {
                            final list = ref.read(selectedDay).state;
                            final isExists =
                                list.firstWhereOrNull((element) => element.value == e.value);
                            if (isExists == null) {
                              ref.read(selectedDay).state = [...list, e];
                              log('masuk sini');
                            } else {
                              ref.read(selectedDay).state = [
                                ...list.where((element) => element.value != e.value).toList()
                              ];
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              color: isExists == null ? e.color.withOpacity(.1) : e.color,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                e.description,
                                style: fontsMontserratAlternate.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleDay {
  final String value;
  final String description;
  final Color color;
  ScheduleDay({
    required this.value,
    required this.description,
    required this.color,
  });
}

final listScheduleDay = <ScheduleDay>[
  ScheduleDay(value: 'senin', description: 'Senin', color: const Color(0xFF359EA6)),
  ScheduleDay(value: 'selasa', description: 'Selasa', color: const Color(0xFF473885)),
  ScheduleDay(value: 'rabu', description: 'Rabu', color: const Color(0xFFFABE19)),
  ScheduleDay(value: 'kamis', description: 'Kamis', color: const Color(0xFFF3631B)),
  ScheduleDay(value: 'jumat', description: 'Jumat', color: const Color(0xFF8C2466)),
  ScheduleDay(value: 'sabtu', description: 'Sabtu', color: const Color(0xFF36405F)),
  ScheduleDay(value: 'minggu', description: 'Minggu', color: const Color(0xFF368476)),
];
