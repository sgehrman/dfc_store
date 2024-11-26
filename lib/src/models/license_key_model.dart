import 'package:collection/collection.dart';
import 'package:dfc_store/src/models/license_response_model.dart';
import 'package:dfc_store/src/models/registered_domain_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'license_key_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class LicenseKeyModel extends LicenseResponseModel {
  const LicenseKeyModel({
    required String result,
    required String message,
    int errorCode = 0,
    this.licenseKey = '',
    this.status = '',
    this.maxAllowedDomains = '',
    this.email = '',
    this.registeredDomains = const [],
    this.dateCreated = '',
    this.dateRenewed = '',
    this.dateExpiry = '',
    this.date = '',
    this.productRef = '',
    this.firstName = '',
    this.lastName = '',
    this.txnId = '',
    this.subscrId = '',
  }) : super(
          message: message,
          result: result,
          errorCode: errorCode,
        );

  factory LicenseKeyModel.error() {
    final base = LicenseResponseModel.error();

    return LicenseKeyModel(
      message: base.message,
      result: base.result,
      errorCode: base.errorCode,
    );
  }

  factory LicenseKeyModel.fromJson(Map<String, dynamic> json) =>
      _$LicenseKeyModelFromJson(json);

  final String licenseKey;
  final String status; // 'active'
  final String maxAllowedDomains;
  final String email;
  final List<RegisteredDomainModel> registeredDomains;
  final String dateCreated;
  final String dateRenewed;
  final String dateExpiry;
  final String date;
  final String productRef;
  final String firstName;
  final String lastName;
  final String txnId;
  final String subscrId;

// currently Deckr doesn't check if email matches, but PF does.
  bool check({
    required String licenseKey,
    required String machineId,
  }) {
    return checkLicense(licenseKey: licenseKey) &&
        isRegistedOnDomain(machineId);
  }

  // makes sure email entered matches the purchasing email
  bool checkAll({
    required String licenseKey,
    required String email,
    required String machineId,
  }) {
    return check(
          licenseKey: licenseKey,
          machineId: machineId,
        ) &&
        this.email == email;
  }

  // make sure license is active and the email matches
  bool checkLicenseAndEmail({
    required String licenseKey,
    required String email,
  }) {
    return checkLicense(licenseKey: licenseKey) && this.email == email;
  }

  bool checkLicense({
    required String licenseKey,
  }) {
    return isSuccess && isActive && this.licenseKey == licenseKey;
  }

  bool isRegistedOnDomain(String domain) {
    return registeredDomains
        .any((element) => element.registeredDomain == domain);
  }

  RegisteredDomainModel? modelForDomain(String domain) {
    return registeredDomains
        .firstWhereOrNull((element) => element.registeredDomain == domain);
  }

  bool get isActive => status == 'active';
  bool get isExpired => status == 'expired';
  bool get isPending => status == 'pending';
  bool get isBlocked => status == 'blocked';

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  Map<String, dynamic> toJson() => _$LicenseKeyModelToJson(this);
}
