import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showLoadingDialog(BuildContext context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sedang Proses'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );

final fontsMontserratAlternate = GoogleFonts.montserratAlternates();
final fontComfortaa = GoogleFonts.comfortaa();
