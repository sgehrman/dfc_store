import 'package:dfc_flutter/dfc_flutter_web_lite.dart';

class PrefsDotIo {
  // ----------------------------------------------------
  // restUrl

  static const String kRestUrlPrefKey = 'rest-url';
  static String get restUrl => Preferences().stringPref(
        key: kRestUrlPrefKey,
        // defaultValue: '',
      );

  static set restUrl(String value) {
    Preferences().setStringPref(
      key: kRestUrlPrefKey,
      value: value,
    );
  }

  // ----------------------------------------------------
  // webDomain

  static const String kWebDomainPrefKey = 'web-domain';
  static String get webDomain => Preferences().stringPref(
        key: kWebDomainPrefKey,
        // defaultValue: '',
      );

  static set webDomain(String value) {
    Preferences().setStringPref(
      key: kWebDomainPrefKey,
      value: value,
    );
  }

  // ----------------------------------------------------
  // apiPassword

  static const String kApiPasswordPrefKey = 'password';
  static String get apiPassword => Preferences().stringPref(
        key: kApiPasswordPrefKey,
        // defaultValue: '',
      );

  static set apiPassword(String value) {
    Preferences().setStringPref(
      key: kApiPasswordPrefKey,
      value: value,
    );
  }

  // ----------------------------------------------------
  // verifySecret

  static const String kVerifySecretPrefKey = 'verify-secret';
  static String get verifySecret => Preferences().stringPref(
        key: kVerifySecretPrefKey,
        // defaultValue: '',
      );

  static set verifySecret(String value) {
    Preferences().setStringPref(
      key: kVerifySecretPrefKey,
      value: value,
    );
  }

  // ----------------------------------------------------
  // licenseKey

  static const String kLicenseKeyPrefKey = 'license-key';
  static String get licenseKey => Preferences().stringPref(
        key: kLicenseKeyPrefKey,
        // defaultValue: '',
      );

  static set licenseKey(String value) {
    Preferences().setStringPref(
      key: kLicenseKeyPrefKey,
      value: value,
    );
  }

  // ----------------------------------------------------
  // email

  static const String kEmailPrefKey = 'email-key';
  static String get email => Preferences().stringPref(
        key: kEmailPrefKey,
        // defaultValue: '',
      );

  static set email(String value) {
    Preferences().setStringPref(
      key: kEmailPrefKey,
      value: value,
    );
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
    Preferences().setStringPref(
      key: kMachineIdPrefKey,
      value: value,
    );
  }
}
