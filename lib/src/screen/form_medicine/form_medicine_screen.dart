import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../network/my_network.dart';
import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';

class FormMedicineScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/form-medicine';
  final MedicineModel? medicine;

  const FormMedicineScreen({
    required this.medicine,
  });
  @override
  _FormMedicineScreenState createState() => _FormMedicineScreenState();
}

class _FormMedicineScreenState extends ConsumerState<FormMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  int? selectedDropdown;
  MedicineCategoryModel? selectedMedicineCategory;
  TypeSchedule? selectedTypeSchedule;
  @override
  void initState() {
    if (widget.medicine == null) {
      nameController = TextEditingController();
      descriptionController = TextEditingController();
    } else {
      final medicine = ref.read(medicineById(widget.medicine!.id!)).state;
      nameController = TextEditingController(text: medicine?.name);
      descriptionController = TextEditingController(text: medicine?.description);
      selectedMedicineCategory = medicine?.medicineCategory;
      selectedTypeSchedule = medicine?.typeSchedule;

      /// Jika ingin meng-initialize stateProvider
      /// Gunakan [addPostFrameCallback]
      /// karena mengubah state harus setelah widget dibuat
      /// Detail [https://stackoverflow.com/questions/66835759/how-to-initialize-stateprovider-from-constructor-in-riverpod]
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
    });
    final medicineDetail = ref.watch(MedicineDetailProvider.provider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
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
            IconButton(
              onPressed: () async {
                final validate = _formKey.currentState?.validate() ?? false;
                if (!validate) {
                  return;
                }

                Map<String, dynamic> result = {};
                try {
                  ref.read(isLoading).state = true;
                  final idMedicineCategory = selectedMedicineCategory?.id;
                  final typeSchedule = selectedTypeSchedule;

                  if (idMedicineCategory == null) {
                    throw Exception('Kategori obat tidak boleh kosong');
                  }
                  if (typeSchedule == null) {
                    throw Exception('Tipe Jadwal minum obat tidak boleh kosong');
                  }

                  final user = ref.read(sessionLogin).state;
                  if (medicineDetail == null) {
                    result = await ref.read(MedicineProvider.provider.notifier).add(
                          idMedicineCategory: idMedicineCategory,
                          idUser: user?.id ?? 0,
                          name: nameController.text,
                          description: descriptionController.text,
                          typeSchedule: typeSchedule,
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
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (medicineDetail == null)
                  AnimatedSwitcher(
                    duration: kThemeAnimationDuration,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: colorPallete.info,
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 1),
                        ],
                      ),
                      child: const Text(
                        'Untuk menambah jam minum obat, silahkan simpan data terlebih dahulu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20.0),
                Text(
                  'Informasi Obat',
                  style: fontsMontserratAlternate.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
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
                                onChanged: (value) => selectedMedicineCategory = value,
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
                                itemBuilder: (item) =>
                                    Text(item == TypeSchedule.daily ? "Harian" : "Mingguan"),
                                selectedItem: selectedTypeSchedule,
                                onChanged: (value) => selectedTypeSchedule = value,
                                labelText: 'Tipe Jadwal',
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                if (medicineDetail != null)
                  AnimatedSwitcher(
                    duration: kThemeAnimationDuration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Penentuan Jadwal',
                          style: fontsMontserratAlternate.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20.0),
                                // Ink(
                                //   decoration: BoxDecoration(
                                //     border: Border.all(color: colorPallete.accentColor!),
                                //     borderRadius: BorderRadius.circular(10.0),
                                //   ),
                                //   child: ListView.builder(
                                //     itemCount: weekList.length,
                                //     shrinkWrap: true,
                                //     physics: const NeverScrollableScrollPhysics(),
                                //     itemBuilder: (context, index) {
                                //       final week = weekList[index];
                                //       return Theme(
                                //         data: Theme.of(context).copyWith(
                                //           unselectedWidgetColor: colorPallete.accentColor,
                                //         ),
                                //         child: CheckboxListTile(
                                //           controlAffinity: ListTileControlAffinity.leading,
                                //           value: true,
                                //           title: Text(week.title),
                                //           onChanged: (value) => '',
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),

                                Consumer(
                                  builder: (context, ref, child) {
                                    final medicineSchedule = ref
                                        .watch(medicineScheduleByIdMedicine(medicineDetail.id ?? 0))
                                        .state;
                                    if (medicineSchedule.isEmpty) {
                                      return const Text('Jadwal obat kamu masih kosong nich...');
                                    }
                                    return ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          Divider(color: colorPallete.accentColor?.withOpacity(.5)),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: medicineSchedule.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final schedule = medicineSchedule[index];
                                        return ListTile(
                                          leading: Ink(
                                            height: 30,
                                            width: 30,
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: colorPallete.primaryColor,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Text(
                                              '${index + 1}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          title: Text(
                                            schedule.startSchedule ?? '',
                                            style: fontsMontserratAlternate.copyWith(),
                                          ),
                                          trailing: Wrap(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  try {
                                                    final result = await ref
                                                        .read(MedicineScheduleProvider
                                                            .provider.notifier)
                                                        .delete(
                                                          id: schedule.id ?? 0,
                                                        );

                                                    GlobalFunction.showSnackBar(
                                                      context,
                                                      content: Text(result['message'] as String),
                                                      snackBarType: SnackBarType.success,
                                                    );
                                                  } catch (e) {
                                                    GlobalFunction.showSnackBar(
                                                      context,
                                                      content: Text(e.toString()),
                                                      snackBarType: SnackBarType.error,
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  FeatherIcons.trash,
                                                  color: colorPallete.error,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  try {
                                                    final timeSplit =
                                                        (schedule.startSchedule ?? '00:00')
                                                            .split(':');
                                                    log('timeSplit $timeSplit');
                                                    final timer = await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay(
                                                        hour: int.tryParse(timeSplit[0]) ?? 0,
                                                        minute: int.tryParse(timeSplit[1]) ?? 0,
                                                      ),
                                                    );
                                                    if (timer != null) {
                                                      final hour = timer.hour < 10
                                                          ? '0${timer.hour}'
                                                          : '${timer.hour}';
                                                      final minute = timer.minute < 10
                                                          ? '0${timer.minute}'
                                                          : '${timer.minute}';
                                                      final result = await ref
                                                          .read(MedicineScheduleProvider
                                                              .provider.notifier)
                                                          .update(
                                                            id: schedule.id ?? 0,
                                                            startSchedule: '$hour:$minute',
                                                            endSchedule: '$hour:$minute',
                                                          );
                                                      GlobalFunction.showSnackBar(
                                                        context,
                                                        content: Text(result['message'] as String),
                                                        snackBarType: SnackBarType.success,
                                                      );
                                                    }
                                                  } catch (e) {
                                                    GlobalFunction.showSnackBar(
                                                      context,
                                                      content: Text(e.toString()),
                                                      snackBarType: SnackBarType.error,
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  FeatherIcons.edit,
                                                  color: colorPallete.info,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(height: 20.0),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final timer = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (timer != null) {
                                        try {
                                          final hour =
                                              timer.hour < 10 ? '0${timer.hour}' : '${timer.hour}';
                                          final minute = timer.minute < 10
                                              ? '0${timer.minute}'
                                              : '${timer.minute}';
                                          final result = await ref
                                              .read(MedicineScheduleProvider.provider.notifier)
                                              .post(
                                                idMedicine: medicineDetail.id ?? 0,
                                                startSchedule: '$hour:$minute',
                                                endSchedule: '$hour:$minute',
                                              );
                                          log('result timepicker $result');
                                          GlobalFunction.showSnackBar(
                                            context,
                                            content: Text(result['message'] as String),
                                            snackBarType: SnackBarType.success,
                                          );
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(
                                            context,
                                            content: Text(e.toString()),
                                            snackBarType: SnackBarType.error,
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: colorPallete.success,
                                      padding: const EdgeInsets.all(12.0),
                                    ),
                                    child: const Text(
                                      'Tambah jam minum obat',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    nameController.clear();
    descriptionController.clear();
    // ref.read(selectedMedicineCategory).state = null;
    // ref.read(selectedTypeSchedule).state = null;
  }
}
