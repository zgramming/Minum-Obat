import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../my_network.dart';

part 'medicine_schedule_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class MedicineScheduleModel extends Equatable {
  const MedicineScheduleModel({
    this.id,
    this.startSchedule = '',
    this.endSchedule = '',
    this.uniqLocalNotification = '',
    this.uniqFirebaseNotification = '',
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
    this.medicine = const MedicineModel(),
  });
  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? id;
  final String? startSchedule;
  final String? endSchedule;
  final String? uniqLocalNotification;
  final String? uniqFirebaseNotification;
  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? createBy;
  final DateTime? createDate;
  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? updateBy;
  final DateTime? updateDate;
  final MedicineModel? medicine;

  factory MedicineScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineScheduleModelToJson(this);

  @override
  List get props {
    return [
      id,
      startSchedule,
      endSchedule,
      uniqLocalNotification,
      uniqFirebaseNotification,
      createBy,
      createDate,
      updateBy,
      updateDate,
      medicine,
    ];
  }

  @override
  bool get stringify => true;

  MedicineScheduleModel copyWith({
    int? id,
    String? startSchedule,
    String? endSchedule,
    String? uniqLocalNotification,
    String? uniqFirebaseNotification,
    int? createBy,
    DateTime? createDate,
    int? updateBy,
    DateTime? updateDate,
    MedicineModel? medicine,
  }) {
    return MedicineScheduleModel(
      id: id ?? this.id,
      startSchedule: startSchedule ?? this.startSchedule,
      endSchedule: endSchedule ?? this.endSchedule,
      uniqLocalNotification: uniqLocalNotification ?? this.uniqLocalNotification,
      uniqFirebaseNotification: uniqFirebaseNotification ?? this.uniqFirebaseNotification,
      createBy: createBy ?? this.createBy,
      createDate: createDate ?? this.createDate,
      updateBy: updateBy ?? this.updateBy,
      updateDate: updateDate ?? this.updateDate,
      medicine: medicine ?? this.medicine,
    );
  }
}
