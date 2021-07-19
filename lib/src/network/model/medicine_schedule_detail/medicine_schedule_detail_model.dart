import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../my_network.dart';

part 'medicine_schedule_detail_model.g.dart';

enum SpecificDay {
  @JsonValue('daily')
  daily,
  @JsonValue('senin')
  senin,
  @JsonValue('selasa')
  selasa,
  @JsonValue('rabu')
  rabu,
  @JsonValue('kamis')
  kamis,
  @JsonValue('jumat')
  jumat,
  @JsonValue('sabtu')
  sabtu,
  @JsonValue('minggu')
  minggu,
}

// ignore: constant_identifier_names
const SpecificDayValues = <SpecificDay, String>{
  SpecificDay.daily: 'daily',
  SpecificDay.senin: 'senin',
  SpecificDay.selasa: 'selasa',
  SpecificDay.rabu: 'rabu',
  SpecificDay.kamis: 'kamis',
  SpecificDay.jumat: 'jumat',
  SpecificDay.sabtu: 'sabtu',
  SpecificDay.minggu: 'minggu',
};

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class MedicineScheduleDetailModel extends Equatable {
  const MedicineScheduleDetailModel({
    this.id,
    this.specificDay = SpecificDay.daily,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
    this.medicine,
  });

  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? id;
  final SpecificDay specificDay;
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

  factory MedicineScheduleDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineScheduleDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineScheduleDetailModelToJson(this);

  @override
  List get props {
    return [
      id,
      specificDay,
      createBy,
      createDate,
      updateBy,
      updateDate,
      medicine,
    ];
  }

  @override
  bool get stringify => true;

  MedicineScheduleDetailModel copyWith({
    int? id,
    SpecificDay? specificDay,
    int? createBy,
    DateTime? createDate,
    int? updateBy,
    DateTime? updateDate,
    MedicineModel? medicine,
  }) {
    return MedicineScheduleDetailModel(
      id: id ?? this.id,
      specificDay: specificDay ?? this.specificDay,
      createBy: createBy ?? this.createBy,
      createDate: createDate ?? this.createDate,
      updateBy: updateBy ?? this.updateBy,
      updateDate: updateDate ?? this.updateDate,
      medicine: medicine ?? this.medicine,
    );
  }
}
