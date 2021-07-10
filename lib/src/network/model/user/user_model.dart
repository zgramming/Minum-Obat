import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('another')
  another
}

enum StatusUser {
  @JsonValue('active')
  active,
  @JsonValue('not_active')
  notActive,
  @JsonValue('blocked')
  blocked
}

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? id;
  final String? email;
  final String? password;
  @JsonKey(name: 'full_name')
  final String? fullname;
  final Gender gender;
  final String? image;
  final StatusUser status;
  @JsonKey(name: 'email_otp_code')
  final String? emailOtpCode;
  @JsonKey(name: 'login_at')
  final DateTime? loginAt;
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
  const UserModel({
    this.id,
    this.email,
    this.password,
    this.fullname,
    this.gender = Gender.another,
    this.image,
    this.status = StatusUser.notActive,
    this.emailOtpCode,
    this.loginAt,
    this.createBy,
    this.createDate,
    this.updateBy,
    this.updateDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List get props {
    return [
      id,
      email,
      password,
      fullname,
      gender,
      image,
      status,
      emailOtpCode,
      loginAt,
      createBy,
      createDate,
      updateBy,
      updateDate,
    ];
  }

  @override
  bool get stringify => true;

  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? fullname,
    Gender? gender,
    String? image,
    StatusUser? status,
    String? emailOtpCode,
    DateTime? loginAt,
    int? createBy,
    DateTime? createDate,
    int? updateBy,
    DateTime? updateDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      fullname: fullname ?? this.fullname,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      status: status ?? this.status,
      emailOtpCode: emailOtpCode ?? this.emailOtpCode,
      loginAt: loginAt ?? this.loginAt,
      createBy: createBy ?? this.createBy,
      createDate: createDate ?? this.createDate,
      updateBy: updateBy ?? this.updateBy,
      updateDate: updateDate ?? this.updateDate,
    );
  }
}
