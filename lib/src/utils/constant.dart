import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: avoid_classes_with_only_static_members
class Constant {
  ///* Key SharedPreferences
  String get keySessionLogin => '_keySessionLogin';
  String get keySessionOnboarding => '_keyOnboardingScreen';

  ///* Rest API
  String get _baseUrl => 'http://192.168.42.69/API/api.minum_obat';
  String get baseAPI => _baseUrl;
  String get fullPathAPI => '$_baseUrl/api/v1';
  String get baseImage => '$_baseUrl/assets/images';

  ///* Application Detail
  String get applicationName => 'Minum Obat';
  String get dsnSentry =>
      'https://28e8da2b28664f58a3833f0f7b5eb217@o821166.ingest.sentry.io/5842506';

  ///* Asset Images Path
  String get pathOnboardingImageReminder => '${appConfig.urlImageAsset}/reminder_white.png';
  String get pathOnboardingImageCalendar => '${appConfig.urlImageAsset}/event_white.png';
  String get pathOnboardingImageStatistic => '${appConfig.urlImageAsset}/statistic_white.png';
  String get pathLogoWhite => '${appConfig.urlImageAsset}/logo_white.png';
  String get pathMedsImage => '${appConfig.urlImageAsset}/meds_primary.png';
  String get pathPillImage => '${appConfig.urlImageAsset}/pill_primary.png';
  String get pathSyrupImage => '${appConfig.urlImageAsset}/syrup_primary.png';
  String get pathFreepikImage => '${appConfig.urlImageAsset}/freepik.png';
  String get pathFlaticonImage => '${appConfig.urlImageAsset}/flaticon.png';

  ///* Locale
  String get localeIndonesiaString => 'ID_id';

  ///* Text
  ///
  Map<CalendarFormat, String> get kAvaliableCalendarFormat => const {
        CalendarFormat.month: 'Bulan',
        CalendarFormat.twoWeeks: '2 Minggu',
        CalendarFormat.week: 'Minggu',
      };

  Locale get localeIndonesia => const Locale('id', 'ID');

  /// Url Copyright Website
  String get freepikUrl => 'https://www.freepik.com/';
  String get flaticonUrl => 'https://www.flaticon.com/';
}

final constant = Constant();
