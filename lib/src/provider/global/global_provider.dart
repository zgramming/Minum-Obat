import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../network/my_network.dart';

final isLoading = StateProvider.autoDispose((ref) => false);

final currentIndexBNB = StateProvider.autoDispose<int>((ref) => 0);

final currentFormatCalendar =
    StateProvider.autoDispose<CalendarFormat>((ref) => CalendarFormat.month);

final currentFocuesDayCalendar = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());

// final selectedTypeSchedule = StateProvider.autoDispose<TypeSchedule?>((ref) => null);

// final selectedMedicineCategory = StateProvider.autoDispose<MedicineCategoryModel?>((ref) => null);
