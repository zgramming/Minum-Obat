import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:minum_obat/src/network/my_network.dart';

import '../../main.dart';

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
      case FormChangePassword.routeNamed:
        return route.slideTransition(
            slidePosition: SlidePosition.fromLeft,
            screen: (ctx, animation, secondaryAnimation) => const FormChangePassword());
      case FormMedicine.routeNamed:
        return route.fadeTransition(
          screen: (ctx, animation, secondaryAnimation) {
            final medicine = settings.arguments as MedicineModel?;

            return FormMedicine(medicine: medicine);
          },
        );
      default:
    }
  }
}

final myRoute = MyRoute();
