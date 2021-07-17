import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';
import '../../../utils/my_utils.dart';

class MedicineScheduleItem extends StatelessWidget {
  const MedicineScheduleItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          leading: Image.asset(
            constant.pathSyrupImage,
            fit: BoxFit.cover,
            width: 30.0,
          ),
          title: const Text(
            'Sirup sakit hati',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Jam Minum :',
                    style: TextStyle(fontSize: 10.0),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
                    color: ColorsUtils().getRandomColor(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
              FractionallySizedBox(
                widthFactor: 1,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(12.0),
                    side: BorderSide(color: colorPallete.monochromaticColor!),
                  ),
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      style: fontComfortaa.copyWith(
                          color: colorPallete.monochromaticColor, fontSize: 10.0),
                      children: const [
                        TextSpan(text: 'Sudah diminum pada '),
                        TextSpan(text: '16.30', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: Ink(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: colorPallete.success,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(offset: Offset(2, 2), color: Colors.black45, blurRadius: 4),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: FittedBox(
                child: Icon(FeatherIcons.checkCircle, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
