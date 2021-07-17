import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import './screen/splash/splash_screen.dart';
import './utils/my_utils.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constant.applicationName,
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: [constant.localeIndonesia],
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: colorPallete.primaryColor,
              onPrimary: Colors.white,
              secondary: colorPallete.accentColor,
              onSecondary: Colors.white,
            ),
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        scaffoldBackgroundColor: colorPallete.scaffoldBackgroundColor,
        textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme),
      ),
      home: const SplashScreen(),
      onGenerateRoute: myRoute.configure,
    );
  }
}
