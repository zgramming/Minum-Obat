import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../screen/form_medicine/widgets/form_medicine_detail.dart';

final isLoading = StateProvider.autoDispose((ref) => false);

final currentIndexBNB = StateProvider.autoDispose<int>((ref) {
  ref.onDispose(() {
    log('ondispose index ');
  });
  return 0;
});

final currentFormatCalendar =
    StateProvider.autoDispose<CalendarFormat>((ref) => CalendarFormat.month);

final currentFocuesDayCalendar = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());

final selectedDay = StateProvider.autoDispose<List<ScheduleDay>>((ref) {
  return [];
});
