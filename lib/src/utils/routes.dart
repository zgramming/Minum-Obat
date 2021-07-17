import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../network/my_network.dart';
import '../screen/change_password/change_password_screen.dart';
import '../screen/form_medicine/form_medicine_screen.dart';
import '../screen/login/login_screen.dart';
import '../screen/onboarding/onboarding_screen.dart';
import '../screen/registration/registration_screen.dart';
import '../screen/splash/splash_screen.dart';
import '../screen/welcome/welcome_screen.dart';

class MyRoute {
  Route<dynamic>? configure(RouteSettings settings) {
    final route = RouteAnimation();
    switch (settings.name) {
      case SplashScreen.routeNamed:
        return route.fadeTransition(
          screen: (ctx, animation, secondaryAnimation) => const SplashScreen(),
        );
      case LoginScreen.routeNamed:
        return route.fadeTransition(screen: (ctx, animation, secondaryAnimation) => LoginScreen());
      case OnboardingScreen.routeNamed:
        return route.fadeTransition(
            screen: (ctx, animation, secondaryAnimation) => const OnboardingScreen());
      case RegistrationScreen.routeNamed:
        return route.fadeTransition(
            screen: (ctx, animation, secondaryAnimation) => const RegistrationScreen());
      case WelcomeScreen.routeNamed:
        return route.fadeTransition(
            screen: (ctx, animation, secondaryAnimation) => const WelcomeScreen());
      case ChangePasswordScreen.routeNamed:
        return route.slideTransition(
            slidePosition: SlidePosition.fromLeft,
            screen: (ctx, animation, secondaryAnimation) => const ChangePasswordScreen());
      case FormMedicineScreen.routeNamed:
        return route.fadeTransition(
          screen: (ctx, animation, secondaryAnimation) {
            final medicine = settings.arguments as MedicineModel?;

            return FormMedicineScreen(medicine: medicine);
          },
        );
      default:
    }
  }
}

final myRoute = MyRoute();
