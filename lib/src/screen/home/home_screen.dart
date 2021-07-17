import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../utils/my_utils.dart';
import './widgets/medicine_schedule_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(top: sizes.statusBarHeight(context)),
              decoration: BoxDecoration(
                color: colorPallete.primaryColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              style: fontComfortaa.copyWith(color: Colors.white, fontSize: 18.0),
                              children: [
                                const TextSpan(text: 'Halo, '),
                                TextSpan(
                                  text: 'Zeffry Reynando',
                                  style: fontsMontserratAlternate.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                // TextSpan(text: '\n Mari lihat jadwal kamu hari ini')
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Mari kita lihat ada jadwal apa saja kamu hari ini',
                            style: fontComfortaa.copyWith(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12.0),
                        leading: Image.asset(
                          constant.pathMedsImage,
                          height: 40.0,
                          width: 40.0,
                          fit: BoxFit.cover,
                        ),
                        title: const Text(
                          'Pil penambah kekuatan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Jam Minum :',
                                style: TextStyle(fontSize: 10.0),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0)),
                                color: ColorsUtils().getRandomColor(),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: FittedBox(
                                    child: Text(
                                      '10.00',
                                      style: TextStyle(
                                        fontSize: 8.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Ada apa saja hari ini ?',
              style: fontsMontserratAlternate.copyWith(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => const MedicineScheduleItem(),
            ),
          ],
        ),
      ),
    );
  }
}
