import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';
import '../login/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../welcome/welcome_screen.dart';

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
