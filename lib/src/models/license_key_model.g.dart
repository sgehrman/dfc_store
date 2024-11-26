// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseKeyModel _$LicenseKeyModelFromJson(Map<String, dynamic> json) =>
    LicenseKeyModel(
      result: json['result'] as String,
      message: json['message'] as String,
      errorCode: (json['error_code'] as num?)?.toInt() ?? 0,
      licenseKey: json['license_key'] as String? ?? '',
      status: json['status'] as String? ?? '',
      maxAllowedDomains: json['max_allowed_domains'] as String? ?? '',
      email: json['email'] as String? ?? '',
      registeredDomains: (json['registered_domains'] as List<dynamic>?)
              ?.map((e) =>
                  RegisteredDomainModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dateCreated: json['date_created'] as String? ?? '',
      dateRenewed: json['date_renewed'] as String? ?? '',
      dateExpiry: json['date_expiry'] as String? ?? '',
      date: json['date'] as String? ?? '',
      productRef: json['product_ref'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      txnId: json['txn_id'] as String? ?? '',
      subscrId: json['subscr_id'] as String? ?? '',
    );

Map<String, dynamic> _$LicenseKeyModelToJson(LicenseKeyModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'error_code': instance.errorCode,
      'message': instance.message,
      'license_key': instance.licenseKey,
      'status': instance.status,
      'max_allowed_domains': instance.maxAllowedDomains,
      'email': instance.email,
      'registered_domains':
          instance.registeredDomains.map((e) => e.toJson()).toList(),
      'date_created': instance.dateCreated,
      'date_renewed': instance.dateRenewed,
      'date_expiry': instance.dateExpiry,
      'date': instance.date,
      'product_ref': instance.productRef,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'txn_id': instance.txnId,
      'subscr_id': instance.subscrId,
    };
