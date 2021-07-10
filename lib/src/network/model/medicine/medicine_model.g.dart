// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) {
  return MedicineModel(
    id: GlobalFunction.fromJsonStringToInteger(json['id']),
    name: json['name'] as String?,
    typeSchedule: _$enumDecode(_$TypeScheduleEnumMap, json['type_schedule']),
    frequency: GlobalFunction.fromJsonStringToInteger(json['frequency']),
    description: json['description'] as String?,
    createBy: GlobalFunction.fromJsonStringToInteger(json['create_by']),
    updateBy: GlobalFunction.fromJsonStringToInteger(json['update_by']),
    createDate: json['create_date'] == null
        ? null
        : DateTime.parse(json['create_date'] as String),
    updateDate: json['update_date'] == null
        ? null
        : DateTime.parse(json['update_date'] as String),
    medicineCategory: MedicineCategoryModel.fromJson(
        json['medicine_category'] as Map<String, dynamic>),
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MedicineModelToJson(MedicineModel instance) =>
    <String, dynamic>{
      'id': GlobalFunction.toJsonStringFromInteger(instance.id),
      'name': instance.name,
      'type_schedule': _$TypeScheduleEnumMap[instance.typeSchedule],
      'frequency': GlobalFunction.toJsonStringFromInteger(instance.frequency),
      'description': instance.description,
      'create_by': GlobalFunction.toJsonStringFromInteger(instance.createBy),
      'update_by': GlobalFunction.toJsonStringFromInteger(instance.updateBy),
      'create_date': instance.createDate?.toIso8601String(),
      'update_date': instance.updateDate?.toIso8601String(),
      'medicine_category': instance.medicineCategory,
      'user': instance.user,
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

const _$TypeScheduleEnumMap = {
  TypeSchedule.daily: 'daily',
  TypeSchedule.weekly: 'weekly',
};
