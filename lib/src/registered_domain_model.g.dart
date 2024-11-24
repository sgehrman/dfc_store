// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registered_domain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisteredDomainModel _$RegisteredDomainModelFromJson(
        Map<String, dynamic> json) =>
    RegisteredDomainModel(
      id: json['id'] as String? ?? '',
      licKeyId: json['lic_key_id'] as String? ?? '',
      licKey: json['lic_key'] as String? ?? '',
      registeredDomain: json['registered_domain'] as String? ?? '',
      itemReference: json['item_reference'] as String? ?? '',
    );

Map<String, dynamic> _$RegisteredDomainModelToJson(
        RegisteredDomainModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lic_key_id': instance.licKeyId,
      'lic_key': instance.licKey,
      'registered_domain': instance.registeredDomain,
      'item_reference': instance.itemReference,
    };
