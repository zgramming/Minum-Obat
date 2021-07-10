import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import './src/network/my_network.dart';
import './src/provider/my_provider.dart';
import './src/shimmer/my_shimmer.dart';
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

class SplashScreen extends StatelessWidget {
  static const routeNamed = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final _initializeSession = ref.watch(initializeSession);

          return _initializeSession.when(
            data: (_) {
              return SplashScreenTemplate(
                duration: 1,
                backgroundColor: colorPallete.primaryColor,
                onDoneTimer: (isDone) {
                  final _sessionLogin = ref.read(sessionLogin).state;
                  final _sessionOnboarding = ref.read(sessionOnboarding).state;
                  log('sessionLogin $_sessionLogin\nsessionOnboarding $_sessionOnboarding');
                  if (!_sessionOnboarding) {
                    Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeNamed);
                    return;
                  }

                  if (_sessionLogin == null) {
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
                    return;
                  }

                  Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
                },
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
              );
            },
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
          );
        },
      ),
    );
  }
}

class OnboardingScreen extends ConsumerWidget {
  static const routeNamed = '/onboarding-screen';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: OnboardingPage(
        backgroundOnboarding: colorPallete.primaryColor,
        skipButtonStyle: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
        skipTitleStyle: GoogleFonts.comfortaa(color: Colors.white),
        backgroundColorCircleIndicator: colorPallete.success!,
        onPageChanged: (value) => '',
        onClickNext: (value) => '',
        onClickFinish: () async {
          await ref.read(sessionProvider.notifier).setSessionOnboarding(value: true);
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
        },
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

class LoginScreen extends ConsumerWidget {
  static const routeNamed = '/login-screen';

  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();
    });

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
                        child: Form(
                          key: _formKey,
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
                                controller: _emailController,
                                disableOutlineBorder: false,
                                prefixIcon:
                                    Icon(FeatherIcons.mail, color: colorPallete.accentColor),
                                hintText: 'zeffry.ganteng@gmail.com',
                                labelText: 'Email',
                                borderColor: colorPallete.accentColor,
                                borderFocusColor: colorPallete.accentColor,
                                activeColor: colorPallete.accentColor,
                                validator: (value) =>
                                    (value?.isEmpty ?? false) ? 'Email tidak boleh kosong' : null,
                              ),
                              const SizedBox(height: 20),
                              TextFormFieldCustom(
                                controller: _passwordController,
                                isPassword: true,
                                disableOutlineBorder: false,
                                prefixIcon:
                                    Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                                hintText: '********',
                                labelText: 'Password',
                                borderColor: colorPallete.accentColor,
                                borderFocusColor: colorPallete.accentColor,
                                activeColor: colorPallete.accentColor,
                                onObsecurePasswordIcon: (isObsecure) =>
                                    isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                                validator: (value) => (value?.isEmpty ?? false)
                                    ? 'Password tidak boleh kosong'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  final validate = _formKey.currentState?.validate() ?? false;

                                  if (!validate) {
                                    return;
                                  }
                                  try {
                                    ref.read(isLoading).state = true;
                                    await ref.read(userProvider.notifier).login(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                    ref.read(isLoading).state = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () => Navigator.of(context)
                                            .pushReplacementNamed(WelcomeScreen.routeNamed));
                                  } catch (e) {
                                    GlobalFunction.showSnackBar(
                                      context,
                                      content: Text(e.toString()),
                                      snackBarType: SnackBarType.error,
                                    );
                                    Future.delayed(const Duration(milliseconds: 100),
                                        () => ref.read(isLoading).state = false);
                                  }
                                },
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

class RegistrationScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/registration-screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();
    });
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormFieldCustom(
                      controller: _fullNameController,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.user, color: colorPallete.accentColor),
                      labelText: 'Nama Lengkap',
                      hintText: 'Zeffry Reynando',
                      validator: (value) =>
                          (value?.isEmpty ?? false) ? 'Nama lengkap tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: _emailController,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.mail, color: colorPallete.accentColor),
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      hintText: 'zeffry.reynando@gmail.com',
                      validator: (value) =>
                          (value?.isEmpty ?? false) ? 'Email tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: _passwordController,
                      isPassword: true,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      labelText: 'Password',
                      hintText: '********',
                      validator: (value) =>
                          (value?.isEmpty ?? false) ? 'Password tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: _passwordConfirmController,
                      isPassword: true,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      labelText: 'Ulangi Password',
                      hintText: '********',
                      validator: (value) => (value?.isEmpty ?? false)
                          ? 'Password Konfirmasi tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final validation = _formKey.currentState?.validate() ?? false;

                        if (!validation) {
                          return;
                        }
                        try {
                          ref.read(isLoading).state = true;
                          final registration = await ref.read(userProvider.notifier).registration(
                                fullName: _fullNameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                passwordConfirm: _passwordConfirmController.text,
                              );
                          final message = registration['message'] as String;

                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(message),
                            snackBarType: SnackBarType.success,
                          );
                          ref.read(isLoading).state = false;
                          Future.delayed(
                              const Duration(milliseconds: 500), () => Navigator.of(context).pop());
                        } catch (e) {
                          ref.read(isLoading).state = false;
                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(e.toString()),
                            snackBarType: SnackBarType.error,
                          );
                        }
                      },
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
      ),
    );
  }
}

/// For keep position on PageView [https://stackoverflow.com/questions/61414778/tabbarview-or-indexedstack-for-bottomnavigationbar-flutter]
class WelcomeScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    ref.read(initializeSession.future).then((_) => log('Initialize Session'));
    ref.read(getMedicineCategory.future).then((value) => log('MedicineCategory $value'));
    _pageController = PageController(initialPage: ref.read(currentIndexBNB).state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) => ref.read(currentIndexBNB).state = value,
        children: const [
          HomeScreen(),
          CalendarScreen(),
          MyScheduleMedicineScreen(),
          StatisticScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(pageController: _pageController),
    );
  }
}

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final ImagePicker _picker = ImagePicker();

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
                          child: InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (context) => ActionModalBottomSheet(
                                  typeAction: TypeAction.none,
                                  align: WrapAlignment.center,
                                  children: [
                                    ActionCircleButton(
                                      backgroundColor: colorPallete.info,
                                      foregroundColor: Colors.white,
                                      icon: FeatherIcons.camera,
                                      radius: 40.0,
                                      onTap: () async {
                                        try {
                                          final _pickedFile = await _picker.getImage(
                                            source: ImageSource.camera,
                                            maxHeight: 200,
                                            maxWidth: 200,
                                            imageQuality: 80,
                                          );

                                          if (_pickedFile != null) {
                                            final user = ref.read(sessionLogin).state;
                                            final image = File(_pickedFile.path);
                                            await ref.read(userProvider.notifier).updateImage(
                                                  user?.id ?? 0,
                                                  image: image,
                                                );
                                            setState(() {});
                                          }
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(context,
                                              content: Text(e.toString()),
                                              snackBarType: SnackBarType.error);
                                        }
                                      },
                                    ),
                                    ActionCircleButton(
                                      backgroundColor: colorPallete.success,
                                      foregroundColor: Colors.white,
                                      icon: FeatherIcons.image,
                                      radius: 40.0,
                                      onTap: () async {
                                        try {
                                          final _pickedFile = await _picker.getImage(
                                            source: ImageSource.gallery,
                                            maxHeight: 200,
                                            maxWidth: 200,
                                            imageQuality: 80,
                                          );
                                          if (_pickedFile != null) {
                                            final user = ref.read(sessionLogin).state;
                                            final image = File(_pickedFile.path);
                                            await ref.read(userProvider.notifier).updateImage(
                                                  user?.id ?? 0,
                                                  image: image,
                                                );
                                            setState(() {});
                                          }
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(context,
                                              content: Text(e.toString()),
                                              snackBarType: SnackBarType.error);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Builder(
                              builder: (context) {
                                final user = ref.watch(sessionLogin).state;
                                Widget image;

                                if (user?.image?.isEmpty ?? true) {
                                  image = CircleAvatar(
                                    backgroundColor: colorPallete.accentColor,
                                    radius: 60.0,
                                    child: const Icon(
                                      FeatherIcons.user,
                                      size: 40.0,
                                    ),
                                  );
                                } else {
                                  image = ClipOval(
                                    child: Image.network(
                                      '${constant.baseImage}/users/${user?.image}?v=${DateTime.now().millisecondsSinceEpoch}',
                                      key: ValueKey(
                                          '${constant.baseImage}/users/${user?.image}?v=${DateTime.now().millisecondsSinceEpoch}'),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }

                                return image;
                              },
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final user = ref.watch(sessionLogin).state;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  user?.fullname ?? '',
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
                                  user?.email ?? '',
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
                                        text:
                                            '${GlobalFunction.formatYMD(user?.loginAt ?? DateTime(1970, 10, 10), type: 3)} @${GlobalFunction.formatHM(user?.loginAt ?? DateTime(1970, 10, 10))}',
                                        style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
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
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              try {
                                                final _url = constant.freepikUrl;
                                                await canLaunch(_url)
                                                    ? await launch(_url)
                                                    : throw 'Could not launch $_url';
                                              } catch (e) {
                                                GlobalFunction.showSnackBar(
                                                  context,
                                                  content: Text(e.toString()),
                                                  snackBarType: SnackBarType.error,
                                                );
                                              }
                                            },
                                        ),
                                        const TextSpan(text: ' from '),
                                        TextSpan(
                                            text: 'www.flaticon.com ',
                                            style: GoogleFonts.montserratAlternates(
                                              fontWeight: FontWeight.bold,
                                              color: colorPallete.primaryColor,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                try {
                                                  final _url = constant.flaticonUrl;
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (e) {
                                                  GlobalFunction.showSnackBar(
                                                    context,
                                                    content: Text(e.toString()),
                                                    snackBarType: SnackBarType.error,
                                                  );
                                                }
                                              }),
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
                                  itemCount: listSocialMedia.length,
                                  itemBuilder: (context, index) {
                                    final socialMedia = listSocialMedia[index];
                                    return InkWell(
                                      onTap: () async {
                                        try {
                                          final _url = socialMedia.url;
                                          await canLaunch(_url)
                                              ? await launch(_url)
                                              : throw 'Could not launch $_url';
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(
                                            context,
                                            content: Text(e.toString()),
                                            snackBarType: SnackBarType.error,
                                          );
                                        }
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: colorPallete.primaryColor,
                                        ),
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(24.0),
                                                child: socialMedia.icon,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                socialMedia.name,
                                                style: GoogleFonts.montserratAlternates(
                                                  fontSize: 14.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                      AccountMenuItem(
                        onTap: () async {
                          await ref.read(sessionProvider.notifier).removeSessionLogin();
                          Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
                        },
                        icon: FeatherIcons.logOut,
                        title: 'Keluar',
                        subtitle: 'Jangan lupa untuk kembali lagi ya...',
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

class MyScheduleMedicineScreen extends ConsumerStatefulWidget {
  const MyScheduleMedicineScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MyScheduleMedicineScreenState createState() => _MyScheduleMedicineScreenState();
}

class _MyScheduleMedicineScreenState extends ConsumerState<MyScheduleMedicineScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;

  int _page = 1;
  final int _dataPerPage = 10;
  bool _hasMore = true;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset == _scrollController.position.maxScrollExtent && _hasMore) {
          _page += 1;
          log('currentPage $_page');
          ref.refresh(medicineLoadMore(_page).future).then((value) {
            if (value.length < _dataPerPage) {
              _hasMore = false;
            }
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _futureMedicine = ref.watch(getMedicine);
    final _medicineTabbarDistinct = ref.watch(medicineTabbarDistinct).state;
    return _futureMedicine.when(
      data: (value) {
        return DefaultTabController(
          length: _medicineTabbarDistinct.length,
          child: RefreshIndicator(
            onRefresh: () async {
              _page = 1;
              _hasMore = true;
              ref.refresh(getMedicine);
            },
            notificationPredicate: (notification) {
              if (notification is OverscrollNotification) {
                return notification.depth == 2;
              }
              return notification.depth == 0;
            },
            child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
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
                        onPressed: () => Navigator.of(context).pushNamed(FormMedicine.routeNamed),
                        icon: const Icon(FeatherIcons.plus, color: Colors.white),
                      ),
                    ],
                    bottom: TabBar(
                        indicator: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: colorPallete.accentColor!, width: 4),
                          ),
                        ),
                        tabs: _medicineTabbarDistinct
                            .map((e) => Tab(
                                  child: Text(
                                    e == TypeSchedule.daily ? 'Harian' : 'Mingguan',
                                    style: GoogleFonts.comfortaa(color: Colors.white),
                                  ),
                                ))
                            .toList()),
                  ),
                ),
              ],
              body: Builder(
                builder: (context) {
                  if (_medicineTabbarDistinct.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Kelihatannya kamu belum mempunyai jadwal ?,\n ayo tambah jadwal pertamamu',
                          textAlign: TextAlign.center,
                          style: fontsMontserratAlternate.copyWith(fontSize: 20.0),
                        ),
                      ),
                    );
                  }
                  return TabBarView(
                    children: _medicineTabbarDistinct.map((e) {
                      return MyScheduleMedicineTabMenu(typeSchedule: e);
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        );
      },
      loading: () => const ShimmerScheduleMedicine(),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }
}

class MyScheduleMedicineTabMenu extends ConsumerStatefulWidget {
  const MyScheduleMedicineTabMenu({
    Key? key,
    required this.typeSchedule,
  }) : super(key: key);

  final TypeSchedule typeSchedule;

  @override
  _MyScheduleMedicineTabMenuState createState() => _MyScheduleMedicineTabMenuState();
}

class _MyScheduleMedicineTabMenuState extends ConsumerState<MyScheduleMedicineTabMenu>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer(
      builder: (context, ref, child) {
        final medicines = ref.watch(medicineBySchedule(widget.typeSchedule)).state;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];

            return Card(
              margin: const EdgeInsets.all(12.0),
              child: ExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Center(
                          child: Image.asset(
                            constant.pathMedsImage,
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        medicine.name ?? '',
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
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                FormMedicine.routeNamed,
                                arguments: medicine,
                              );
                              ref
                                  .read(MedicineDetailProvider.provider.notifier)
                                  .setMedicine(medicine);
                            },
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
                                  side: BorderSide(color: colorPallete.error!)),
                            ),
                            child: Text(
                              'Hapus',
                              style: GoogleFonts.comfortaa(color: colorPallete.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen>
    with AutomaticKeepAliveClientMixin {
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
                child: Builder(
                  builder: (context) {
                    final _currentFormatCalendar = ref.watch(currentFormatCalendar).state;
                    final _focusedDayCalendar = ref.watch(currentFocuesDayCalendar).state;
                    return TableCalendar(
                      focusedDay: _focusedDayCalendar,
                      firstDay: DateTime(1999, 4, 4),
                      lastDay: DateTime.now(),
                      calendarFormat: _currentFormatCalendar,
                      onFormatChanged: (format) => ref.read(currentFormatCalendar).state = format,
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
                          ref.read(currentFocuesDayCalendar).state = result;
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

class MyBottomNavigationBar extends ConsumerStatefulWidget {
  final PageController pageController;
  const MyBottomNavigationBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends ConsumerState<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
              currentIndex: ref.watch(currentIndexBNB).state,
              selectedItemColor: colorPallete.primaryColor,
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              onTap: (value) async {
                await widget.pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
                ref.read(currentIndexBNB).state = value;
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

class FormChangePassword extends ConsumerStatefulWidget {
  static const routeNamed = '/change-password';
  const FormChangePassword({Key? key}) : super(key: key);

  @override
  _FormChangePasswordState createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends ConsumerState<FormChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final passwordOldController = TextEditingController();
  final passwordNewController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
    });
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: passwordOldController,
                      hintText: 'Password Lama',
                      labelText: 'Password Lama',
                      disableOutlineBorder: false,
                      isPassword: true,
                      borderColor: colorPallete.accentColor,
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      prefixIcon: const Icon(FeatherIcons.lock),
                      validator: (value) =>
                          GlobalFunction.validateIsEmpty(value, 'Password Lama tidak boleh kosong'),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: passwordNewController,
                      hintText: 'Password Baru',
                      labelText: 'Password Baru',
                      disableOutlineBorder: false,
                      isPassword: true,
                      borderColor: colorPallete.accentColor,
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      prefixIcon: const Icon(FeatherIcons.lock),
                      validator: (value) =>
                          GlobalFunction.validateIsEmpty(value, 'Password Baru tidak boleh kosong'),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: passwordConfirmController,
                      hintText: 'Konfirmasi Password',
                      labelText: 'Konfirmasi Password',
                      disableOutlineBorder: false,
                      isPassword: true,
                      borderColor: colorPallete.accentColor,
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      prefixIcon: const Icon(FeatherIcons.lock),
                      validator: (value) => GlobalFunction.validateIsEmpty(
                          value, 'Password Konfirmasi tidak boleh kosong'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final validate = _formKey.currentState?.validate() ?? false;
                        if (!validate) {
                          return;
                        }

                        try {
                          ref.read(isLoading).state = true;
                          final idUser = ref.read(sessionLogin).state?.id;
                          log('iduser $idUser');
                          final result = await ref.read(userProvider.notifier).updatePassword(
                                idUser ?? 0,
                                passwordOld: passwordOldController.text,
                                passwordNew: passwordNewController.text,
                                passwordConfirm: passwordConfirmController.text,
                              );
                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(result['message'] as String),
                            snackBarType: SnackBarType.success,
                          );

                          /// Reset TextField
                          passwordOldController.clear();
                          passwordNewController.clear();
                          passwordConfirmController.clear();
                          ref.read(isLoading).state = false;
                        } catch (e) {
                          ref.read(isLoading).state = false;

                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(e.toString()),
                            snackBarType: SnackBarType.error,
                          );
                        }
                      },
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
      ),
    );
  }
}

class FormMedicine extends ConsumerStatefulWidget {
  static const routeNamed = '/form-medicine';
  final MedicineModel? medicine;

  const FormMedicine({required this.medicine});
  @override
  _FormMedicineState createState() => _FormMedicineState();
}

class _FormMedicineState extends ConsumerState<FormMedicine> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  @override
  void initState() {
    if (widget.medicine == null) {
      nameController = TextEditingController();
      descriptionController = TextEditingController();
    } else {
      final medicine = ref.read(medicineById(widget.medicine!.id!)).state;
      nameController = TextEditingController(text: medicine?.name);
      descriptionController = TextEditingController(text: medicine?.description);

      /// Jika ingin meng-initialize stateProvider
      /// Gunakan [addPostFrameCallback]
      /// karena mengubah state harus setelah widget dibuat
      /// Detail [https://stackoverflow.com/questions/66835759/how-to-initialize-stateprovider-from-constructor-in-riverpod]
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        ref.read(selectedMedicineCategory).state = medicine!.medicineCategory;
        ref.read(selectedTypeSchedule).state = medicine.typeSchedule;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
    });
    final medicineDetail = ref.watch(MedicineDetailProvider.provider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            'Form Obat',
            style: GoogleFonts.montserratAlternates(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final validate = _formKey.currentState?.validate() ?? false;
                if (!validate) {
                  return;
                }
                try {
                  ref.read(isLoading).state = true;
                  final idMedicineCategory = ref.read(selectedMedicineCategory).state?.id;
                  final typeSchedule = ref.read(selectedTypeSchedule).state;

                  if (idMedicineCategory == null) {
                    throw Exception('Kategori obat tidak boleh kosong');
                  }
                  if (typeSchedule == null) {
                    throw Exception('Tipe Jadwal minum obat tidak boleh kosong');
                  }

                  final idUser = ref.read(sessionLogin).state?.id ?? 0;
                  final result = await ref.read(medicineProvider.notifier).addMedicine(
                        idMedicineCategory: idMedicineCategory,
                        idUser: idUser,
                        name: nameController.text,
                        description: descriptionController.text,
                        typeSchedule: typeSchedule,
                      );
                  ref
                      .read(MedicineDetailProvider.provider.notifier)
                      .setMedicine(result['medicine'] as MedicineModel);
                  GlobalFunction.showSnackBar(
                    context,
                    content: Text(result['message'] as String),
                    snackBarType: SnackBarType.success,
                  );
                  // _resetForm();
                  ref.read(isLoading).state = false;
                } catch (e) {
                  ref.read(isLoading).state = false;
                  GlobalFunction.showSnackBar(
                    context,
                    content: Text(e.toString()),
                    snackBarType: SnackBarType.error,
                  );
                }
              },
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
                AnimatedSwitcher(
                  duration: kThemeAnimationDuration,
                  child: medicineDetail != null
                      ? const SizedBox()
                      : Container(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormFieldCustom(
                            controller: nameController,
                            disableOutlineBorder: false,
                            hintText: 'Obat Sakit Perut, Obat Penurun Panas',
                            labelText: 'Nama Obat',
                            validator: (value) => GlobalFunction.validateIsEmpty(value),
                          ),
                          const SizedBox(height: 20.0),
                          Consumer(
                            builder: (context, ref, child) {
                              final categories = ref.watch(medicineCategoryProvider);
                              final _selectedCategory = ref.watch(selectedMedicineCategory).state;
                              return DropddownCustom<MedicineCategoryModel>(
                                hintText: 'Pilih Kategori Obat',
                                selectedItem: _selectedCategory,
                                items: categories,
                                onChanged: (value) =>
                                    ref.read(selectedMedicineCategory).state = value,
                                builder: (value) => Text(value?.name ?? ''),
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormFieldCustom(
                            controller: descriptionController,
                            disableOutlineBorder: false,
                            hintText: 'Keterangan obat',
                            labelText: 'Keterangan',
                            minLines: 3,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            validator: (value) => GlobalFunction.validateIsEmpty(value),
                          ),
                          const SizedBox(height: 20.0),
                          Consumer(
                            builder: (context, ref, child) {
                              return DropddownCustom<TypeSchedule>(
                                hintText: 'Pilih Tipe Jadwal',
                                selectedItem: ref.watch(selectedTypeSchedule).state,
                                items: const [
                                  TypeSchedule.daily,
                                  TypeSchedule.weekly,
                                ],
                                onChanged: (value) => ref.read(selectedTypeSchedule).state = value,
                                builder: (value) {
                                  return Text(value == TypeSchedule.daily ? "Harian" : "Mingguan");
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Visibility(
                  visible: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Penentuan Jadwal',
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
                                              icon: Icon(FeatherIcons.trash,
                                                  color: colorPallete.error)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    nameController.clear();
    descriptionController.clear();
    ref.read(selectedMedicineCategory).state = null;
    ref.read(selectedTypeSchedule).state = null;
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
