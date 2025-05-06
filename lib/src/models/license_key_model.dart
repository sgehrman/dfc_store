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
    required super.result,
    required super.message,
    super.errorCode,
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
  });

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

  bool check({
    required String licenseKey,
    required String machineId,
    String email = '', // pass in email to check that too
  }) {
    var result =
        isSuccess &&
        isActive &&
        this.licenseKey == licenseKey &&
        isRegistedOnDomain(machineId);

    if (result && email.isNotEmpty) {
      // case sensitive? fix?
      result = email == this.email;
    }

    return result;
  }

  bool verifyLicenseAndEmail({
    required String licenseKey,
    required String email,
  }) {
    return this.licenseKey == licenseKey && this.email == email;
  }

  bool verifyLicense({required String licenseKey}) {
    return this.licenseKey == licenseKey;
  }

  bool isRegistedOnDomain(String domain) {
    return registeredDomains.any(
      (element) => element.registeredDomain == domain,
    );
  }

  RegisteredDomainModel? modelForDomain(String domain) {
    return registeredDomains.firstWhereOrNull(
      (element) => element.registeredDomain == domain,
    );
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
