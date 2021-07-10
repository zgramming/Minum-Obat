import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../my_network.dart';

part 'medicine_model.g.dart';

enum TypeSchedule {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly
}

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class MedicineModel extends Equatable {
  const MedicineModel({
    this.id,
    this.name,
    this.typeSchedule = TypeSchedule.daily,
    this.frequency,
    this.description,
    this.createBy,
    this.updateBy,
    this.createDate,
    this.updateDate,
    this.medicineCategory = const MedicineCategoryModel(),
    this.user = const UserModel(),
  });

  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? id;
  final String? name;
  final TypeSchedule typeSchedule;
  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? frequency;
  final String? description;

  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? createBy;
  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? updateBy;
  final DateTime? createDate;
  final DateTime? updateDate;
  final MedicineCategoryModel medicineCategory;
  final UserModel user;

  factory MedicineModel.fromJson(Map<String, dynamic> json) => _$MedicineModelFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineModelToJson(this);

  @override
  List get props {
    return [
      id,
      name,
      typeSchedule,
      frequency,
      description,
      createBy,
      updateBy,
      createDate,
      updateDate,
      medicineCategory,
      user,
    ];
  }

  @override
  bool get stringify => true;

  MedicineModel copyWith({
    int? id,
    String? name,
    TypeSchedule? typeSchedule,
    int? frequency,
    String? description,
    int? createBy,
    int? updateBy,
    DateTime? createDate,
    DateTime? updateDate,
    MedicineCategoryModel? medicineCategory,
    UserModel? user,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      typeSchedule: typeSchedule ?? this.typeSchedule,
      frequency: frequency ?? this.frequency,
      description: description ?? this.description,
      createBy: createBy ?? this.createBy,
      updateBy: updateBy ?? this.updateBy,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      medicineCategory: medicineCategory ?? this.medicineCategory,
      user: user ?? this.user,
    );
  }
}
