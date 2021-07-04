import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import './src/provider/global/global_provider.dart';
import './src/utils/my_utils.dart';

Future<void> main() async {
  // await initializeDateFormatting();
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
    (options) => options.dsn = constant.dsnSentry,
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
          case RegistrationScreen.routeNamed:
            return route.fadeTransition(
                screen: (ctx, animation, secondaryAnimation) => const RegistrationScreen());
          case WelcomeScreen.routeNamed:
            return route.fadeTransition(
                screen: (ctx, animation, secondaryAnimation) => const WelcomeScreen());
          case FormChangePassword.routeNamed:
            return route.slideTransition(
                slidePosition: SlidePosition.fromLeft,
                screen: (ctx, animation, secondaryAnimation) => const FormChangePassword());
          case FormMedicine.routeNamed:
            return route.fadeTransition(
                screen: (ctx, animation, secondaryAnimation) => const FormMedicine());
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
                constant.pathLogoWhite,
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
              child: Image.asset(constant.pathOnboardingImageReminder),
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
                constant.pathOnboardingImageCalendar,
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
                constant.pathOnboardingImageStatistic,
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
                  child: Align(
                    child: Card(
                      margin: const EdgeInsets.all(24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
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
                              activeColor: colorPallete.accentColor,
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
                              activeColor: colorPallete.accentColor,
                              onObsecurePasswordIcon: (isObsecure) =>
                                  isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context)
                                  .pushReplacementNamed(WelcomeScreen.routeNamed),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(14.0),
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.comfortaa().copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 12),
                            children: [
                              const TextSpan(text: 'Belum punya akun ? '),
                              TextSpan(
                                text: 'Daftar disini',
                                style: GoogleFonts.montserratAlternates(
                                  fontWeight: FontWeight.bold,
                                  color: colorPallete.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context)
                                      .pushNamed(RegistrationScreen.routeNamed),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Atau',
                          style: GoogleFonts.montserratAlternates(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 12),
                            children: [
                              const TextSpan(text: 'Lupa Password ? '),
                              TextSpan(
                                text: 'Reset disini',
                                style: GoogleFonts.montserratAlternates(
                                  fontWeight: FontWeight.bold,
                                  color: colorPallete.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  static const routeNamed = '/registration-screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            FeatherIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Registrasi',
          style: GoogleFonts.montserratAlternates(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormFieldCustom(
                    disableOutlineBorder: false,
                    borderColor: colorPallete.accentColor,
                    prefixIcon: Icon(FeatherIcons.user, color: colorPallete.accentColor),
                    labelText: 'Nama Lengkap',
                    hintText: 'Zeffry Reynando',
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    disableOutlineBorder: false,
                    borderColor: colorPallete.accentColor,
                    prefixIcon: Icon(FeatherIcons.mail, color: colorPallete.accentColor),
                    labelText: 'Email',
                    hintText: 'zeffry.reynando@gmail.com',
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    isPassword: true,
                    disableOutlineBorder: false,
                    borderColor: colorPallete.accentColor,
                    prefixIcon: Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                    onObsecurePasswordIcon: (isObsecure) =>
                        isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                    labelText: 'Password',
                    hintText: '********',
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    isPassword: true,
                    disableOutlineBorder: false,
                    borderColor: colorPallete.accentColor,
                    prefixIcon: Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                    onObsecurePasswordIcon: (isObsecure) =>
                        isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                    labelText: 'Ulangi Password',
                    hintText: '********',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
                    child: Text(
                      'Daftar',
                      style: GoogleFonts.montserratAlternates(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// For keep position on PageView [https://stackoverflow.com/questions/61414778/tabbarview-or-indexedstack-for-bottomnavigationbar-flutter]
class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: context.read(currentIndexBNB).state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) => context.read(currentIndexBNB).state = value,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const HomeScreen(),
          const CalendarScreen(),
          const MyScheduleMedicineScreen(),
          const StatisticScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(pageController: _pageController),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorPallete.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ink(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: colorPallete.accentColor,
                            radius: 60.0,
                            child: const Icon(FeatherIcons.user, size: 40.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Zeffry Reynando',
                          style: GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'zeffry.reynando@gmail.com',
                          style: GoogleFonts.comfortaa(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.comfortaa(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: 10.0,
                                fontWeight: FontWeight.w300),
                            children: [
                              const TextSpan(text: 'Terakhir login pada '),
                              TextSpan(
                                text: '1 Juli 2020 @20.00',
                                style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: colorPallete.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountMenuItem(
                        onTap: () {},
                        icon: FeatherIcons.barChart2,
                        title: 'Export Statistik',
                        subtitle: 'Export hasil statistik kamu selama menggunakan aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () {
                          Navigator.of(context).pushNamed(FormChangePassword.routeNamed);
                        },
                        icon: FeatherIcons.lock,
                        title: 'Ubah Password',
                        subtitle: 'Kami merekomendasikan untuk mengganti password secara berkala',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          showLicensePage(
                            context: context,
                            applicationIcon: CircleAvatar(
                              backgroundColor: colorPallete.primaryColor,
                              foregroundColor: Colors.white,
                              radius: 60.0,
                              backgroundImage: AssetImage(constant.pathLogoWhite),
                            ),
                          );
                        },
                        icon: FeatherIcons.codesandbox,
                        title: 'Lisensi',
                        subtitle: 'Daftar lisensi yang digunakan pada aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          constant.pathFlaticonImage,
                                          width: 60,
                                          height: 60,
                                        ),
                                        Image.asset(
                                          constant.pathFreepikImage,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      style: GoogleFonts.comfortaa(
                                          color: Colors.black, fontSize: 10.0),
                                      children: [
                                        const TextSpan(text: 'Icon made by '),
                                        TextSpan(
                                          text: 'Freepik',
                                          style: GoogleFonts.montserratAlternates(
                                            fontWeight: FontWeight.bold,
                                            color: colorPallete.primaryColor,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()..onTap = () => '',
                                        ),
                                        const TextSpan(text: ' from '),
                                        TextSpan(
                                            text: 'www.flaticon.com ',
                                            style: GoogleFonts.montserratAlternates(
                                              fontWeight: FontWeight.bold,
                                              color: colorPallete.primaryColor,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()..onTap = () => ''),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: FeatherIcons.flag,
                        title: 'Copyright',
                        subtitle: 'Copyright yang ada pada aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () {},
                        icon: FeatherIcons.info,
                        title: 'Tentang Aplikasi',
                        subtitle: 'Segala sesuatu yang ingin kamu tahu dari aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            builder: (context) => FractionallySizedBox(
                              heightFactor: .6,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 32.0,
                                    mainAxisSpacing: 32.0,
                                  ),
                                  itemCount: 10,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {},
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: colorPallete.primaryColor,
                                      ),
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Expanded(
                                            child: Center(
                                              child: Icon(
                                                FeatherIcons.linkedin,
                                                color: Colors.white,
                                                size: 40.0,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'LinkedIn',
                                              style: GoogleFonts.montserratAlternates(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        icon: FeatherIcons.meh,
                        title: 'Tentang Developer',
                        subtitle:
                            'Punya pertanyaan yang mengganjal hatimu atau hanya ingin lebih dekat denganku ?',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const AccountMenuItem({
    Key? key,
    this.icon = FeatherIcons.home,
    this.title = 'Title',
    this.subtitle = 'Subtitle',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(12.0),
      leading: Icon(
        icon,
        color: Colors.white,
        size: 40.0,
      ),
      title: Text(
        title,
        style: GoogleFonts.montserratAlternates(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 10.0),
          Divider(
            thickness: 1,
            color: Colors.white.withOpacity(.5),
          )
        ],
      ),
    );
  }
}

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
          style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold, fontSize: 40.0),
        ),
      ),
    );
  }
}

class MyScheduleMedicineScreen extends StatefulWidget {
  const MyScheduleMedicineScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MyScheduleMedicineScreenState createState() => _MyScheduleMedicineScreenState();
}

class _MyScheduleMedicineScreenState extends State<MyScheduleMedicineScreen>
    with SingleTickerProviderStateMixin {
  final tabs = <String>['Harian', 'Mingguan'];
  final tabs2 = <String, String>{'harian': 'Harian', 'mingguna': 'Mingguan'};

  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            title: Text(
              'Jadwal Obatku',
              style: GoogleFonts.montserratAlternates(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(FormMedicine.routeNamed);
                  },
                  icon: const Icon(FeatherIcons.plus, color: Colors.white)),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colorPallete.accentColor!, width: 4),
                ),
              ),
              tabs: tabs2.entries
                  .map((e) => Tab(
                        child: Text(
                          e.value,
                          style: GoogleFonts.comfortaa(color: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
          ),
        )
      ],
      body: TabBarView(
        controller: _tabController,
        children: tabs2.entries
            .map((e) => Builder(
                  builder: (context) {
                    if (e.key == 'harian') {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Center(
                                            child: Image.asset(
                                              constant.pathMedsImage,
                                              width: 60.0,
                                              height: 60.0,
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          Text(
                                            'Pil Penambah Kekuatan',
                                            style: GoogleFonts.comfortaa(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  'Hari Minum',
                                                  style: GoogleFonts.comfortaa(fontSize: 10.0),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 9,
                                                child: Wrap(
                                                  spacing: 10.0,
                                                  runSpacing: 10.0,
                                                  children: [
                                                    Card(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(60.0)),
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
                                            ],
                                          ),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {},
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
                                                  onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets.all(12.0),
                                                    primary: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side:
                                                            BorderSide(color: colorPallete.error!)),
                                                  ),
                                                  child: Text(
                                                    'Hapus',
                                                    style: GoogleFonts.comfortaa(
                                                        color: colorPallete.error),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(FeatherIcons.chevronDown),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }
                    return Text(e.value);
                  },
                ))
            .toList(),
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Consumer(
                  builder: (context, watch, child) {
                    final _currentFormatCalendar = watch(currentFormatCalendar).state;
                    final _focusedDayCalendar = watch(currentFocuesDayCalendar).state;
                    return TableCalendar(
                      focusedDay: _focusedDayCalendar,
                      firstDay: DateTime(1999, 4, 4),
                      lastDay: DateTime.now(),
                      calendarFormat: _currentFormatCalendar,
                      onFormatChanged: (format) =>
                          context.read(currentFormatCalendar).state = format,
                      locale: constant.localeIndonesiaString,
                      availableCalendarFormats: constant.kAvaliableCalendarFormat,
                      headerStyle: HeaderStyle(
                        titleTextStyle: GoogleFonts.montserratAlternates(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      onHeaderTapped: (focusedDay) async {
                        final result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1999, 4, 4),
                          lastDate: DateTime.now(),
                          locale: constant.localeIndonesia,
                          builder: (context, child) => child ?? const SizedBox(),
                        );
                        if (result != null) {
                          context.read(currentFocuesDayCalendar).state = result;
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => const MedicineScheduleItem(),
            )),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

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
                              style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 18.0),
                              children: [
                                const TextSpan(text: 'Halo, '),
                                TextSpan(
                                  text: 'Zeffry Reynando',
                                  style:
                                      GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold),
                                ),
                                // TextSpan(text: '\n Mari lihat jadwal kamu hari ini')
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Mari kita lihat ada jadwal apa saja kamu hari ini',
                            style: GoogleFonts.comfortaa(fontSize: 10, color: Colors.white),
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
              style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                      style: GoogleFonts.comfortaa(
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

class MyBottomNavigationBar extends StatefulWidget {
  final PageController pageController;
  const MyBottomNavigationBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _currentIndexBNB = watch(currentIndexBNB).state;
        return Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 4.0),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _currentIndexBNB,
              selectedItemColor: colorPallete.primaryColor,
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              onTap: (value) async {
                await widget.pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
                context.read(currentIndexBNB).state = value;
              },
              items: [
                const BottomNavigationBarItem(icon: Icon(FeatherIcons.home), label: 'Beranda'),
                const BottomNavigationBarItem(
                  icon: Icon(FeatherIcons.calendar),
                  label: 'Kalendar',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                    height: 32,
                    width: 32,
                    child: Image.asset(constant.pathMedsImage),
                  ),
                  label: 'Obatku',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(FeatherIcons.barChart),
                  label: 'Statistik',
                ),
                const BottomNavigationBarItem(icon: Icon(FeatherIcons.user), label: 'Akun'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FormChangePassword extends StatefulWidget {
  static const routeNamed = '/change-password';
  const FormChangePassword({Key? key}) : super(key: key);

  @override
  _FormChangePasswordState createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends State<FormChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            FeatherIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Ubah Password',
          style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    hintText: 'Password Lama',
                    labelText: 'Password Lama',
                    disableOutlineBorder: false,
                    isPassword: true,
                    borderColor: colorPallete.accentColor,
                    onObsecurePasswordIcon: (isObsecure) =>
                        isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                    prefixIcon: const Icon(FeatherIcons.lock),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    hintText: 'Password Baru',
                    labelText: 'Password Baru',
                    disableOutlineBorder: false,
                    isPassword: true,
                    borderColor: colorPallete.accentColor,
                    onObsecurePasswordIcon: (isObsecure) =>
                        isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                    prefixIcon: const Icon(FeatherIcons.lock),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    hintText: 'Konfirmasi Password',
                    labelText: 'Konfirmasi Password',
                    disableOutlineBorder: false,
                    isPassword: true,
                    borderColor: colorPallete.accentColor,
                    onObsecurePasswordIcon: (isObsecure) =>
                        isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                    prefixIcon: const Icon(FeatherIcons.lock),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(12.0)),
                    child: Text(
                      'Ubah',
                      style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormMedicine extends StatefulWidget {
  static const routeNamed = '/form-medicine';
  const FormMedicine({Key? key}) : super(key: key);

  @override
  _FormMedicineState createState() => _FormMedicineState();
}

class _FormMedicineState extends State<FormMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            FeatherIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Form Obat',
          style: GoogleFonts.montserratAlternates(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FeatherIcons.save,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Dismissible(
                key: UniqueKey(),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorPallete.info,
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 1),
                    ],
                  ),
                  child: const Text(
                    'Untuk menambah jam minum obat, silahkan simpan data terlebih dahulu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Informasi Obat',
                style: GoogleFonts.montserratAlternates(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const TextFormFieldCustom(
                        disableOutlineBorder: false,
                        hintText: 'Obat Sakit Perut, Obat Penurun Panas',
                        labelText: 'Nama Obat',
                      ),
                      const SizedBox(height: 20.0),
                      DropddownCustom<String>(
                        hintText: 'Pilih Kategori Obat',
                        items: const ['Pill', 'Kapsul', 'Sir up'],
                        onChanged: (value) => log('value $value'),
                        valueItem: (value) => value,
                        builder: (value) => Text(value.toString()),
                      ),
                      const SizedBox(height: 20.0),
                      const TextFormFieldCustom(
                        disableOutlineBorder: false,
                        hintText: 'Keterangan obat',
                        labelText: 'Keterangan',
                        minLines: 3,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 20.0),
                      DropddownCustom<TypeScheduleModel>(
                        hintText: 'Pilih Tipe Jadwal',
                        items: const [
                          TypeScheduleModel(),
                          TypeScheduleModel(
                            value: 'weekly',
                            typeScheduleItem: TypeScheduleItem.weekly,
                          ),
                        ],
                        onChanged: (value) => context.read(currentTypeSchedule).state = value,
                        valueItem: (value) => value,
                        builder: (value) => Text(value?.value ?? ''),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Penentuan Jadwal',
                style: GoogleFonts.montserratAlternates(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),

              // const SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Ink(
                        decoration: BoxDecoration(
                          border: Border.all(color: colorPallete.accentColor!),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListView.builder(
                          itemCount: weekList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final week = weekList[index];
                            return Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: colorPallete.accentColor,
                              ),
                              child: CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                value: true,
                                title: Text(week.title),
                                onChanged: (value) => '',
                              ),
                            );
                          },
                        ),
                      ),
                      if (timeScheduleMedicineList.isEmpty) ...[
                        const SizedBox(height: 20.0),
                        const Center(child: Text('Daftar minum obat belum ada nih')),
                      ] else ...[
                        const SizedBox(height: 20.0),
                        ListView.separated(
                          separatorBuilder: (context, index) =>
                              Divider(color: colorPallete.accentColor?.withOpacity(.5)),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: timeScheduleMedicineList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final schedule = timeScheduleMedicineList[index];
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
                                '${schedule.hour}:${schedule.minute}',
                                style: GoogleFonts.montserratAlternates(),
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(FeatherIcons.trash, color: colorPallete.error)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        FeatherIcons.edit,
                                        color: colorPallete.info,
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (result != null) {
                              log('result timepicker $result');
                              setState(() {
                                timeScheduleMedicineList.add(result);
                              });
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
        ),
      ),
    );
  }
}

class WeekModel extends Equatable {
  const WeekModel({
    this.codeValue = 1,
    this.value = 'senin',
    this.title = 'Senin',
  });

  final int codeValue;
  final String value;
  final String title;

  @override
  List<Object> get props => [codeValue, value, title];

  @override
  bool get stringify => true;

  WeekModel copyWith({
    int? codeValue,
    String? value,
    String? title,
  }) {
    return WeekModel(
      codeValue: codeValue ?? this.codeValue,
      value: value ?? this.value,
      title: title ?? this.title,
    );
  }
}

const weekList = [
  WeekModel(),
  WeekModel(codeValue: 2, value: 'selasa', title: 'Selasa'),
  WeekModel(codeValue: 3, value: 'rabu', title: 'Rabu'),
  WeekModel(codeValue: 4, value: 'kamis', title: 'Kamis'),
  WeekModel(codeValue: 5, value: "jumat", title: "Juma't"),
  WeekModel(codeValue: 6, value: 'sabtu', title: 'Sabtu'),
  WeekModel(codeValue: 7, value: 'minggu', title: 'Minggu'),
];

final timeScheduleMedicineList = <TimeOfDay>[];

enum TypeScheduleItem { daily, weekly }

class TypeScheduleModel extends Equatable {
  final String value;
  final TypeScheduleItem typeScheduleItem;
  const TypeScheduleModel({
    this.value = 'daily',
    this.typeScheduleItem = TypeScheduleItem.daily,
  });

  @override
  List<Object> get props => [value, typeScheduleItem];

  @override
  bool get stringify => true;

  TypeScheduleModel copyWith({
    String? value,
    TypeScheduleItem? typeScheduleItem,
  }) {
    return TypeScheduleModel(
      value: value ?? this.value,
      typeScheduleItem: typeScheduleItem ?? this.typeScheduleItem,
    );
  }
}
