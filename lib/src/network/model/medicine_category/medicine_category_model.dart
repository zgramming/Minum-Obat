import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medicine_category_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class MedicineCategoryModel extends Equatable {
  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? id;
  final String? name;
  final String? description;
  final String? image;
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

  const MedicineCategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.createBy,
    this.updateBy,
    this.createDate,
    this.updateDate,
  });
  factory MedicineCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$MedicineCategoryModelToJson(this);

  @override
  List get props {
    return [
      id,
      name,
      description,
      image,
      createBy,
      updateBy,
      createDate,
      updateDate,
    ];
  }

  @override
  bool get stringify => true;

  MedicineCategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    int? createBy,
    int? updateBy,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return MedicineCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      createBy: createBy ?? this.createBy,
      updateBy: updateBy ?? this.updateBy,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }
}
