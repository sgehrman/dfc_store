import 'package:dfc_flutter/dfc_flutter_web_lite.dart';

class Prefs {
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
}
