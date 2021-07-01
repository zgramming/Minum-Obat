import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import './src/utils/my_utils.dart';

Future<void> main() async {
  await initializeDateFormatting();
  appConfig.configuration(
    nameLogoAsset: 'logo.png',
  );
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
    (options) => options.dsn = Constant.dsnSentry,
    appRunner: () => runApp(
      ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constant.applicationName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: colorPallete.primaryColor,
              onPrimary: colorPallete.primaryColor,
              secondary: colorPallete.accentColor,
              onSecondary: colorPallete.accentColor,
            ),
        scaffoldBackgroundColor: colorPallete.scaffoldBackgroundColor,
        textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme),
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        final route = RouteAnimation();
        switch (settings.name) {
          case SplashScreen.routeNamed:
            return route.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const SplashScreen(),
            );
          case LoginScreen.routeNamed:
            return route.fadeTransition(
                screen: (ctx, animation, secondaryAnimation) => const LoginScreen());
          case OnboardingScreen.routeNamed:
            return route.fadeTransition(
                screen: (ctx, animation, secondaryAnimation) => const OnboardingScreen());
          default:
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  static const routeNamed = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenTemplate(
        backgroundColor: colorPallete.primaryColor,
        onDoneTimer: (isDone) =>
            Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeNamed),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Image.asset(
                '${appConfig.urlImageAsset}/${Constant.logoWhite}',
                scale: 1.5,
              ),
            ),
          ),
          CopyRightVersion(
            backgroundColor: Colors.white,
            colorText: colorPallete.primaryColor!,
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  static const routeNamed = '/onboarding-screen';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPage(
        backgroundOnboarding: colorPallete.primaryColor,
        skipButtonStyle: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
        skipTitleStyle: GoogleFonts.comfortaa(color: Colors.white),
        backgroundColorCircleIndicator: colorPallete.success!,
        onPageChanged: (value) => '',
        onClickNext: (value) => '',
        onClickFinish: () => Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed),
        items: [
          OnboardingItem(
            logo: FractionallySizedBox(
              widthFactor: .4,
              child: Image.asset(
                '${appConfig.urlImageAsset}/${Constant.onboardingImageReminder}',
              ),
            ),
            title: 'Teman Pengingatmu',
            titleStyle: GoogleFonts.montserratAlternates(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            subtitle: 'Teman yang akan mengingatkanmu kapan jadwal minum obatmu',
            subtitleStyle: GoogleFonts.comfortaa(color: Colors.white),
          ),
          OnboardingItem(
            logo: FractionallySizedBox(
              widthFactor: .4,
              child: Image.asset(
                '${appConfig.urlImageAsset}/${Constant.onboardingImageCalendar}',
                fit: BoxFit.cover,
              ),
            ),
            title: 'Teman Pengelolamu',
            titleStyle: GoogleFonts.montserratAlternates(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            subtitle: 'Teman yang akan membantumu untuk menambahkan jadwal minum obat',
            subtitleStyle: GoogleFonts.comfortaa(color: Colors.white),
          ),
          OnboardingItem(
            logo: FractionallySizedBox(
              widthFactor: .4,
              child: Image.asset(
                '${appConfig.urlImageAsset}/${Constant.onboardingImageStatistic}',
                fit: BoxFit.cover,
              ),
            ),
            title: 'Teman Perhitunganmu',
            titleStyle: GoogleFonts.montserratAlternates(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            subtitle: 'Teman yang akan memberika statistik selama kamu menggunakan aplikasi ini',
            subtitleStyle: GoogleFonts.comfortaa(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  static const routeNamed = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: sizes.height(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Image.asset(
                      appConfig.fullPathImageAsset,
                      fit: BoxFit.cover,
                      scale: 1.75,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Card(
                    margin: const EdgeInsets.all(24.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Selamat Datang',
                              style: GoogleFonts.montserratAlternates(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormFieldCustom(
                            disableOutlineBorder: false,
                            prefixIcon: Icon(FeatherIcons.mail, color: colorPallete.accentColor),
                            hintText: 'zeffry.ganteng@gmail.com',
                            labelText: 'Email',
                            borderColor: colorPallete.accentColor,
                            borderFocusColor: colorPallete.accentColor,
                            activeColor: colorPallete.accentColor!,
                          ),
                          const SizedBox(height: 20),
                          TextFormFieldCustom(
                            isPassword: true,
                            disableOutlineBorder: false,
                            prefixIcon: Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                            hintText: '********',
                            labelText: 'Password',
                            borderColor: colorPallete.accentColor,
                            borderFocusColor: colorPallete.accentColor,
                            activeColor: colorPallete.accentColor!,
                            onObsecurePasswordIcon: (isObsecure) =>
                                isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Text('data')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
