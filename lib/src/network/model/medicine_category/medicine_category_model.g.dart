// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineCategoryModel _$MedicineCategoryModelFromJson(
    Map<String, dynamic> json) {
  return MedicineCategoryModel(
    id: GlobalFunction.fromJsonStringToInteger(json['id']),
    name: json['name'] as String?,
    description: json['description'] as String?,
    image: json['image'] as String?,
    createBy: GlobalFunction.fromJsonStringToInteger(json['create_by']),
    updateBy: GlobalFunction.fromJsonStringToInteger(json['update_by']),
    createDate: json['create_date'] == null
        ? null
        : DateTime.parse(json['create_date'] as String),
    updateDate: json['update_date'] == null
        ? null
        : DateTime.parse(json['update_date'] as String),
  );
}

Map<String, dynamic> _$MedicineCategoryModelToJson(
        MedicineCategoryModel instance) =>
    <String, dynamic>{
      'id': GlobalFunction.toJsonStringFromInteger(instance.id),
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'create_by': GlobalFunction.toJsonStringFromInteger(instance.createBy),
      'update_by': GlobalFunction.toJsonStringFromInteger(instance.updateBy),
      'create_date': instance.createDate?.toIso8601String(),
      'update_date': instance.updateDate?.toIso8601String(),
    };
