import 'package:admin_app/misc/prefs_dot_com.dart';
import 'package:admin_app/misc/prefs_dot_io.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart';

class Prefs {
  // ----------------------------------------------------
  // .com or .io

  static const String kUseCocoatechDotComPrefKey = 'use-cocoatech-dot-com';
  static bool get useCocoatechDotCom => Preferences().boolPref(
        key: kUseCocoatechDotComPrefKey,
      );

  static set useCocoatechDotCom(bool value) {
    Preferences().setBoolPref(
      key: kUseCocoatechDotComPrefKey,
      value: value,
    );
  }

  // ----------------------------------------------------
  // restUrl

  static String get restUrl {
    if (useCocoatechDotCom) {
      return PrefsDotCom.restUrl;
    }

    return PrefsDotIo.restUrl;
  }

  static set restUrl(String value) {
    if (useCocoatechDotCom) {
      PrefsDotCom.restUrl = value;
    } else {
      PrefsDotIo.restUrl = value;
    }
  }

  // ----------------------------------------------------
  // webDomain

  static String get webDomain {
    if (useCocoatechDotCom) {
      return PrefsDotCom.webDomain;
    }

    return PrefsDotIo.webDomain;
  }

  static set webDomain(String value) {
    if (useCocoatechDotCom) {
      PrefsDotCom.webDomain = value;
    } else {
      PrefsDotIo.webDomain = value;
    }
  }

  // ----------------------------------------------------
  // apiPassword

  static String get apiPassword {
    if (useCocoatechDotCom) {
      return PrefsDotCom.apiPassword;
    }

    return PrefsDotIo.apiPassword;
  }

  static set apiPassword(String value) {
    if (useCocoatechDotCom) {
      PrefsDotCom.apiPassword = value;
    } else {
      PrefsDotIo.apiPassword = value;
    }
  }

  // ----------------------------------------------------
  // verifySecret

  static String get verifySecret {
    if (useCocoatechDotCom) {
      return PrefsDotCom.verifySecret;
    }

    return PrefsDotIo.verifySecret;
  }

  static set verifySecret(String value) {
    if (useCocoatechDotCom) {
      PrefsDotCom.verifySecret = value;
    } else {
      PrefsDotIo.verifySecret = value;
    }
  }

  // ----------------------------------------------------
  // licenseKey

  static String get licenseKey {
    if (useCocoatechDotCom) {
      return PrefsDotCom.licenseKey;
    }

    return PrefsDotIo.licenseKey;
  }

  static set licenseKey(String value) {
    if (useCocoatechDotCom) {
      PrefsDotCom.licenseKey = value;
    } else {
      PrefsDotIo.licenseKey = value;
    }
  }

  // ----------------------------------------------------
  // email

  static String get email {
    if (useCocoatechDotCom) {
      return PrefsDotCom.email;
    }

    return PrefsDotIo.email;
  }

  static set email(String value) {
    if (useCocoatechDotCom) {
      PrefsDotCom.email = value;
    } else {
      PrefsDotIo.email = value;
    }
  }

  // ----------------------------------------------------
  // machineId

  static String get machineId {
    if (useCocoatechDotCom) {
      return PrefsDotCom.machineId;
    }

    return PrefsDotIo.machineId;
  }

  static set machineId(String value) {
    if (useCocoatechDotCom) {
      PrefsDotCom.machineId = value;
    } else {
      PrefsDotIo.machineId = value;
    }
  }
}
