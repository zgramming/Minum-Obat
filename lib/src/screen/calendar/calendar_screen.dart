import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';
import '../home/widgets/medicine_schedule_item.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Builder(
                  builder: (context) {
                    final _currentFormatCalendar = ref.watch(currentFormatCalendar).state;
                    final _focusedDayCalendar = ref.watch(currentFocuesDayCalendar).state;
                    return TableCalendar(
                      focusedDay: _focusedDayCalendar,
                      firstDay: DateTime(1999, 4, 4),
                      lastDay: DateTime.now(),
                      calendarFormat: _currentFormatCalendar,
                      onFormatChanged: (format) => ref.read(currentFormatCalendar).state = format,
                      locale: constant.localeIndonesiaString,
                      availableCalendarFormats: constant.kAvaliableCalendarFormat,
                      headerStyle: HeaderStyle(
                        titleTextStyle: fontsMontserratAlternate.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      onHeaderTapped: (focusedDay) async {
                        final result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1999, 4, 4),
                          lastDate: DateTime.now(),
                          locale: constant.localeIndonesia,
                          builder: (context, child) => child ?? const SizedBox(),
                        );
                        if (result != null) {
                          ref.read(currentFocuesDayCalendar).state = result;
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => const MedicineScheduleItem(),
            )),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
