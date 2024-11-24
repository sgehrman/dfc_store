// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseResponseModel _$LicenseResponseModelFromJson(
        Map<String, dynamic> json) =>
    LicenseResponseModel(
      result: json['result'] as String,
      message: json['message'] as String,
      errorCode: (json['error_code'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LicenseResponseModelToJson(
        LicenseResponseModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'error_code': instance.errorCode,
      'message': instance.message,
    };
