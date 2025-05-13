// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slm_license_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlmLicenseModel _$SlmLicenseModelFromJson(Map<String, dynamic> json) =>
    SlmLicenseModel(
      id: json['id'] as String? ?? '',
      licenseKey: json['license_key'] as String? ?? '',
      maxAllowedDomains: json['max_allowed_domains'] as String? ?? '',
      licStatus: json['lic_status'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      txnId: json['txn_id'] as String? ?? '',
      dateCreated: json['date_created'] as String? ?? '',
      dateRenewed: json['date_renewed'] as String? ?? '',
      dateExpiry: json['date_expiry'] as String? ?? '',
      productRef: json['product_ref'] as String? ?? '',
    );

Map<String, dynamic> _$SlmLicenseModelToJson(SlmLicenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'license_key': instance.licenseKey,
      'max_allowed_domains': instance.maxAllowedDomains,
      'lic_status': instance.licStatus,
      'email': instance.email,
      'company_name': instance.companyName,
      'txn_id': instance.txnId,
      'date_created': instance.dateCreated,
      'date_renewed': instance.dateRenewed,
      'date_expiry': instance.dateExpiry,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'product_ref': instance.productRef,
    };
