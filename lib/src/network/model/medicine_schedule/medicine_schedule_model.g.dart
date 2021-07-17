// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineScheduleModel _$MedicineScheduleModelFromJson(
    Map<String, dynamic> json) {
  return MedicineScheduleModel(
    id: GlobalFunction.fromJsonStringToInteger(json['id']),
    startSchedule: json['start_schedule'] as String?,
    endSchedule: json['end_schedule'] as String?,
    uniqLocalNotification: json['uniq_local_notification'] as String?,
    uniqFirebaseNotification: json['uniq_firebase_notification'] as String?,
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

Map<String, dynamic> _$MedicineScheduleModelToJson(
        MedicineScheduleModel instance) =>
    <String, dynamic>{
      'id': GlobalFunction.toJsonStringFromInteger(instance.id),
      'start_schedule': instance.startSchedule,
      'end_schedule': instance.endSchedule,
      'uniq_local_notification': instance.uniqLocalNotification,
      'uniq_firebase_notification': instance.uniqFirebaseNotification,
      'create_by': GlobalFunction.toJsonStringFromInteger(instance.createBy),
      'create_date': instance.createDate?.toIso8601String(),
      'update_by': GlobalFunction.toJsonStringFromInteger(instance.updateBy),
      'update_date': instance.updateDate?.toIso8601String(),
      'medicine': instance.medicine,
    };
