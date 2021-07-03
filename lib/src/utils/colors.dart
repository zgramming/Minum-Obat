import 'dart:math';

import 'package:flutter/material.dart';

class ColorsUtils {
  final _arrColor = const <Color>[
    Color(0xFF00706F),
    Color(0xFF187F55),
    Color(0xFF6E8948),
    Color(0xFF9F0028),
    Color(0xFF419CD8),
  ];

  Color getRandomColor() {
    final _random = Random();
    final color = _arrColor[_random.nextInt(_arrColor.length)];
    return color;
  }
}
