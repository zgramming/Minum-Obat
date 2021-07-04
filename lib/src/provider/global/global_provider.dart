import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minum_obat/main.dart';
import 'package:table_calendar/table_calendar.dart';

final currentIndexBNB = StateProvider.autoDispose<int>((ref) => 0);

final currentFormatCalendar =
    StateProvider.autoDispose<CalendarFormat>((ref) => CalendarFormat.month);

final currentFocuesDayCalendar = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());

final currentTypeSchedule = StateProvider.autoDispose<TypeScheduleModel?>((ref) => null);
