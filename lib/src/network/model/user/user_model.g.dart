// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: GlobalFunction.fromJsonStringToInteger(json['id']),
    email: json['email'] as String?,
    password: json['password'] as String?,
    fullname: json['full_name'] as String?,
    gender: _$enumDecode(_$GenderEnumMap, json['gender']),
    image: json['image'] as String?,
    status: _$enumDecode(_$StatusUserEnumMap, json['status']),
    emailOtpCode: json['email_otp_code'] as String?,
    loginAt: json['login_at'] == null
        ? null
        : DateTime.parse(json['login_at'] as String),
    createBy: GlobalFunction.fromJsonStringToInteger(json['create_by']),
    createDate: json['create_date'] == null
        ? null
        : DateTime.parse(json['create_date'] as String),
    updateBy: GlobalFunction.fromJsonStringToInteger(json['update_by']),
    updateDate: json['update_date'] == null
        ? null
        : DateTime.parse(json['update_date'] as String),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': GlobalFunction.toJsonStringFromInteger(instance.id),
      'email': instance.email,
      'password': instance.password,
      'full_name': instance.fullname,
      'gender': _$GenderEnumMap[instance.gender],
      'image': instance.image,
      'status': _$StatusUserEnumMap[instance.status],
      'email_otp_code': instance.emailOtpCode,
      'login_at': instance.loginAt?.toIso8601String(),
      'create_by': GlobalFunction.toJsonStringFromInteger(instance.createBy),
      'create_date': instance.createDate?.toIso8601String(),
      'update_by': GlobalFunction.toJsonStringFromInteger(instance.updateBy),
      'update_date': instance.updateDate?.toIso8601String(),
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

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.another: 'another',
};

const _$StatusUserEnumMap = {
  StatusUser.active: 'active',
  StatusUser.notActive: 'not_active',
  StatusUser.blocked: 'blocked',
};
