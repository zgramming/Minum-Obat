import 'package:flutter/material.dart';
import '../../utils/my_utils.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: 1,
        child: Text(
          'Statistic Screen',
          style: fontsMontserratAlternate.copyWith(fontWeight: FontWeight.bold, fontSize: 40.0),
        ),
      ),
    );
  }
}
