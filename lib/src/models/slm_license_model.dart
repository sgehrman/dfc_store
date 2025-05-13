import 'package:json_annotation/json_annotation.dart';

part 'slm_license_model.g.dart';

//  result from 'lookup_email'

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class SlmLicenseModel {
  const SlmLicenseModel({
    this.id = '',
    this.licenseKey = '',
    this.maxAllowedDomains = '',
    this.licStatus = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.companyName = '',
    this.txnId = '',
    this.dateCreated = '',
    this.dateRenewed = '',
    this.dateExpiry = '',
    this.productRef = '',
  });

  factory SlmLicenseModel.fromJson(Map<String, dynamic> json) =>
      _$SlmLicenseModelFromJson(json);

  final String id;
  final String licenseKey;
  final String maxAllowedDomains;
  final String licStatus;
  final String email;
  final String companyName;
  final String txnId;
  final String dateCreated;
  final String dateRenewed;
  final String dateExpiry;
  final String firstName;
  final String lastName;
  final String productRef;

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  Map<String, dynamic> toJson() => _$SlmLicenseModelToJson(this);
}
