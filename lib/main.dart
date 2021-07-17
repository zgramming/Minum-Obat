import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './src/app.dart';
import './src/utils/my_utils.dart';

Future<void> main() async {
  // await initializeDateFormatting();
  appConfig.configuration(nameLogoAsset: 'logo.png');
  colorPallete.configuration(
    primaryColor: const Color(0xFFEEA4A7),
    accentColor: const Color(0xFF9F7C9D),
    monochromaticColor: const Color(0xFFC37D80),
    scaffoldBackgroundColor: const Color(0xFFFFE4E5),
    success: const Color(0xFF61BB46),
    warning: const Color(0xFFFDB827),
    info: const Color(0xFF419CD8),
    error: const Color(0xFF9F0028),
  );
  await SentryFlutter.init(
    (options) => options.dsn = constant.dsnSentry,
    appRunner: () => runApp(
      ProviderScope(child: MyApp()),
    ),
  );
}
