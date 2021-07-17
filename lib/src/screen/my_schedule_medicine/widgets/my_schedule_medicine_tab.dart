import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';
import '../../../utils/my_utils.dart';
import '../../form_medicine/form_medicine_screen.dart';

class MyScheduleMedicineTabMenu extends ConsumerStatefulWidget {
  const MyScheduleMedicineTabMenu({
    Key? key,
    required this.typeSchedule,
  }) : super(key: key);

  final TypeSchedule typeSchedule;

  @override
  _MyScheduleMedicineTabMenuState createState() => _MyScheduleMedicineTabMenuState();
}

class _MyScheduleMedicineTabMenuState extends ConsumerState<MyScheduleMedicineTabMenu>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer(
      builder: (context, ref, child) {
        final medicines = ref.watch(medicineBySchedule(widget.typeSchedule)).state;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];

            return Card(
              margin: const EdgeInsets.all(12.0),
              child: ExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Center(
                          child: Image.asset(
                            constant.pathMedsImage,
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        medicine.name ?? '',
                        style: fontComfortaa.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Hari Minum',
                              style: fontComfortaa.copyWith(fontSize: 10.0),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Consumer(
                              builder: (context, ref, child) {
                                final medicineSchedule =
                                    ref.watch(medicineScheduleByIdMedicine(medicine.id ?? 0)).state;
                                return Wrap(
                                  runSpacing: 10.0,
                                  children: medicineSchedule
                                      .map(
                                        (schedule) => Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(60.0)),
                                          color: ColorsUtils().getRandomColor(),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 4.0),
                                            child: Text(
                                              schedule.startSchedule ?? '',
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                FormMedicineScreen.routeNamed,
                                arguments: medicine,
                              );
                              ref
                                  .read(MedicineDetailProvider.provider.notifier)
                                  .setMedicine(medicine);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12.0),
                              primary: colorPallete.info,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text('Ubah'),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final result = await ref
                                    .read(MedicineProvider.provider.notifier)
                                    .delete(id: medicine.id ?? 0);
                                final message = result['message'] as String;

                                GlobalFunction.showSnackBar(
                                  context,
                                  content: Text(message),
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
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12.0),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: colorPallete.error!)),
                            ),
                            child: Text(
                              'Hapus',
                              style: fontComfortaa.copyWith(color: colorPallete.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
