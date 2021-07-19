import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../network/my_network.dart';
import '../../provider/my_provider.dart';
import '../../shimmer/my_shimmer.dart';
import '../../utils/my_utils.dart';
import '../form_medicine/form_medicine_screen.dart';
import './widgets/my_schedule_medicine_tab.dart';

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
    return _futureMedicine.when(
      data: (value) {
        final _medicineTabbarDistinct = ref.watch(medicineTabbarDistinct).state;
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
                      style: fontsMontserratAlternate.copyWith(
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
                        onPressed: () =>
                            Navigator.of(context).pushNamed(FormMedicineScreen.routeNamed),
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
                                    style: fontComfortaa.copyWith(color: Colors.white),
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
                    children: _medicineTabbarDistinct
                        .map((e) => MyScheduleMedicineTabMenu(typeSchedule: e))
                        .toList(),
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
