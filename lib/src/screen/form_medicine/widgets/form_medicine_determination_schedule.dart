import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:minum_obat/src/provider/my_provider.dart';
import 'package:minum_obat/src/utils/my_utils.dart';

class FormMedicineDeterminationSchedule extends ConsumerWidget {
  const FormMedicineDeterminationSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineDetail = ref.watch(MedicineDetailProvider.provider);
    return AnimatedSwitcher(
      duration: const Duration(seconds: 10),
      child: medicineDetail == null
          ? SizedBox(key: UniqueKey())
          : Column(
              key: UniqueKey(),
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
                                                .read(MedicineScheduleProvider.provider.notifier)
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
                                                (schedule.startSchedule ?? '00:00').split(':');
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
                                                  .read(MedicineScheduleProvider.provider.notifier)
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
                                  final hour = timer.hour < 10 ? '0${timer.hour}' : '${timer.hour}';
                                  final minute =
                                      timer.minute < 10 ? '0${timer.minute}' : '${timer.minute}';
                                  final medicineDetail = ref.read(MedicineDetailProvider.provider);
                                  final result = await ref
                                      .read(MedicineScheduleProvider.provider.notifier)
                                      .post(
                                        idMedicine: medicineDetail?.id ?? 0,
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
    );
  }
}
