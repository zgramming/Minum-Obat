// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_schedule_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineScheduleDetailModel _$MedicineScheduleDetailModelFromJson(
    Map<String, dynamic> json) {
  return MedicineScheduleDetailModel(
    id: GlobalFunction.fromJsonStringToInteger(json['id']),
    specificDay: _$enumDecode(_$SpecificDayEnumMap, json['specific_day']),
    createBy: GlobalFunction.fromJsonStringToInteger(json['create_by']),
    createDate: json['create_date'] == null
        ? null
        : DateTime.parse(json['create_date'] as String),
    updateBy: GlobalFunction.fromJsonStringToInteger(json['update_by']),
    updateDate: json['update_date'] == null
        ? null
        : DateTime.parse(json['update_date'] as String),
    medicine: json['medicine'] == null
        ? null
        : MedicineModel.fromJson(json['medicine'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MedicineScheduleDetailModelToJson(
        MedicineScheduleDetailModel instance) =>
    <String, dynamic>{
      'id': GlobalFunction.toJsonStringFromInteger(instance.id),
      'specific_day': _$SpecificDayEnumMap[instance.specificDay],
      'create_by': GlobalFunction.toJsonStringFromInteger(instance.createBy),
      'create_date': instance.createDate?.toIso8601String(),
      'update_by': GlobalFunction.toJsonStringFromInteger(instance.updateBy),
      'update_date': instance.updateDate?.toIso8601String(),
      'medicine': instance.medicine,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$SpecificDayEnumMap = {
  SpecificDay.daily: 'daily',
  SpecificDay.senin: 'senin',
  SpecificDay.selasa: 'selasa',
  SpecificDay.rabu: 'rabu',
  SpecificDay.kamis: 'kamis',
  SpecificDay.jumat: 'jumat',
  SpecificDay.sabtu: 'sabtu',
  SpecificDay.minggu: 'minggu',
};
