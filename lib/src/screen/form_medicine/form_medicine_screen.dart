import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/my_network.dart';
import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';

import './widgets/form_medicine_appbar.dart';
import './widgets/form_medicine_detail.dart';
import './widgets/form_medicine_determination_schedule.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: FormMedicineAppbar(
          descriptionController: descriptionController,
          nameController: nameController,
          selectedMedicineCategory: selectedMedicineCategory,
          selectedTypeSchedule: selectedTypeSchedule,
          formKey: _formKey,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  'Informasi Obat',
                  style: fontsMontserratAlternate.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                FormMedicineDetail(
                  formKey: _formKey,
                  nameController: nameController,
                  descriptionController: descriptionController,
                  selectedMedicineCategory: selectedMedicineCategory,
                  selectedTypeSchedule: selectedTypeSchedule,
                  onChangedMedicineCategory: (medicineCategory) =>
                      selectedMedicineCategory = medicineCategory,
                  onChangedTypeSchedule: (typeSchedule) =>
                      setState(() => selectedTypeSchedule = typeSchedule),
                ),
                const SizedBox(height: 20.0),
                const FormMedicineDeterminationSchedule(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
