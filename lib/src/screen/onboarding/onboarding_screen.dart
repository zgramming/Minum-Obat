import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';
import '../login/login_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  static const routeNamed = '/onboarding-screen';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: OnboardingPage(
        backgroundOnboarding: colorPallete.primaryColor,
        skipButtonStyle: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
        skipTitleStyle: fontComfortaa.copyWith(color: Colors.white),
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
            titleStyle: fontsMontserratAlternate.copyWith(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            subtitle: 'Teman yang akan mengingatkanmu kapan jadwal minum obatmu',
            subtitleStyle: fontComfortaa.copyWith(color: Colors.white),
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
            titleStyle: fontsMontserratAlternate.copyWith(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            subtitle: 'Teman yang akan membantumu untuk menambahkan jadwal minum obat',
            subtitleStyle: fontComfortaa.copyWith(color: Colors.white),
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
            titleStyle: fontsMontserratAlternate.copyWith(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            subtitle: 'Teman yang akan memberika statistik selama kamu menggunakan aplikasi ini',
            subtitleStyle: fontComfortaa.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
