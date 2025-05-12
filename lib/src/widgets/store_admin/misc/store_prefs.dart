import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:dfc_store/src/widgets/store_admin/misc/web_store_domain.dart';

class StorePrefs {
  // ----------------------------------------------------
  // apiPassword

  static const String kApiPasswordPrefKey = 'password';
  static String apiPassword(WebStoreDomain domain) {
    return Preferences().stringPref(key: domain.formKey(kApiPasswordPrefKey));
  }

  static void setApiPassword(WebStoreDomain domain, String value) {
    Preferences().setStringPref(
      key: domain.formKey(kApiPasswordPrefKey),
      value: value,
    );
  }

  // ----------------------------------------------------
  // verifySecret

  static const String kVerifySecretPrefKey = 'verify-secret';
  static String verifySecret(WebStoreDomain domain) {
    return Preferences().stringPref(key: domain.formKey(kVerifySecretPrefKey));
  }

  static void setVerifySecret(WebStoreDomain domain, String value) {
    Preferences().setStringPref(
      key: domain.formKey(kVerifySecretPrefKey),
      value: value,
    );
  }

  // ----------------------------------------------------
  // licenseKey

  static const String kLicenseKeyPrefKey = 'license-key';
  static String get licenseKey =>
      Preferences().stringPref(key: kLicenseKeyPrefKey);

  static set licenseKey(String value) {
    Preferences().setStringPref(key: kLicenseKeyPrefKey, value: value);
  }

  // ----------------------------------------------------
  // email

  static const String kEmailPrefKey = 'email-key';
  static String get email => Preferences().stringPref(key: kEmailPrefKey);

  static set email(String value) {
    Preferences().setStringPref(key: kEmailPrefKey, value: value);
  }

  // ----------------------------------------------------
  // machineId

  static const String kMachineIdPrefKey = 'machine-id';
  static String get machineId {
    return Preferences().stringPref(
      key: kMachineIdPrefKey,
      defaultValue: '2024-mac-pro-1234',
    );
  }

  static set machineId(String value) {
    Preferences().setStringPref(key: kMachineIdPrefKey, value: value);
  }

  // ----------------------------------------------------
  // webStoreDomain

  static const String kWebStoreDomainPrefKey = 'web-store-domain';
  static WebStoreDomain get webStoreDomain {
    final result = Preferences().intPref(
      key: kWebStoreDomainPrefKey,
      defaultValue: WebStoreDomain.cocoatechIo.index,
    );

    return WebStoreDomain.values[result];
  }

  static set webStoreDomain(WebStoreDomain value) {
    Preferences().setIntPref(key: kWebStoreDomainPrefKey, value: value.index);
  }
}
