import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/my_provider.dart';
import '../../../utils/my_utils.dart';

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
