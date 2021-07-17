import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/my_provider.dart';
import '../account/account_screen.dart';
import '../calendar/calendar_screen.dart';
import '../home/home_screen.dart';
import '../my_schedule_medicine/my_schedule_medicine_screen.dart';
import '../statistic/statistic_screen.dart';
import './widgets/bottom_navigation_bar.dart';

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
