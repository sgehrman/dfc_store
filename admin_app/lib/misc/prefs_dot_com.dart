import 'package:dfc_flutter/dfc_flutter_web_lite.dart';

class PrefsDotCom {
  static const _suffix = '-dot-com';

  // ----------------------------------------------------
  // restUrl

  static const String kRestUrlPrefKey = 'rest-url$_suffix';
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

  static const String kWebDomainPrefKey = 'web-domain$_suffix';
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

  static const String kApiPasswordPrefKey = 'password$_suffix';
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

  static const String kVerifySecretPrefKey = 'verify-secret$_suffix';
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

  static const String kLicenseKeyPrefKey = 'license-key$_suffix';
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

  static const String kEmailPrefKey = 'email-key$_suffix';
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

  static const String kMachineIdPrefKey = 'machine-id$_suffix';
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
