import 'dart:convert';

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:dfc_store/src/license_key_model.dart';
import 'package:dfc_store/src/license_response_model.dart';
import 'package:http/http.dart' as http;

// Because of cors error from the SLM api, we only call it from the server
// use the LicenseKeyClient() on the frontend

class LicenseKeyServer {
  LicenseKeyServer({
    required this.webDomain,
    required this.restAPIUrl,
    required this.licenseVerificationKey,
  });

  final String webDomain;
  final String licenseVerificationKey;
  final String restAPIUrl;

  // flutter: {"result":"error","message":"Invalid license key","error_code":60}
  Future<LicenseKeyModel> check(String licenseKey) async {
    final Uri uri = Uri.https(webDomain, '', {
      'secret_key': licenseVerificationKey,
      'slm_action': 'slm_check',
      'license_key': licenseKey,
    });

    try {
      final response = await HttpUtils.httpGet(uri);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final map =
            Map<String, dynamic>.from(json.decode(response.body) as Map? ?? {});

        return LicenseKeyModel.fromJson(map);
      }
    } catch (err) {
      print('LicenseKeyServer check err: $err');
    }

    return LicenseKeyModel.error();
  }

  // flutter: {"result":"success","message":"License key activated"}
  // flutter: {"result":"error","message":"License key already in use on my_mac","error_code":40}
  Future<LicenseResponseModel> activate({
    required String licenseKey,
    required String domain,
  }) async {
    final Uri uri = Uri.https(webDomain, '', {
      'secret_key': licenseVerificationKey,
      'slm_action': 'slm_activate',
      'license_key': licenseKey,
      'registered_domain': domain,
    });

    try {
      final response = await HttpUtils.httpGet(uri);

      final map =
          Map<String, dynamic>.from(json.decode(response.body) as Map? ?? {});

      return LicenseResponseModel.fromJson(map);
    } catch (err) {
      print('LicenseKeyServer activate err: $err');
    }

    return LicenseResponseModel.error();
  }

  // flutter: {"result":"success","message":"The license key has been deactivated for this domain"}
  // flutter: {"result":"error","message":"The license key on this domain is already inactive","error_code":80}
  Future<LicenseResponseModel> deactivate({
    required String licenseKey,
    required String domain,
  }) async {
    final Uri uri = Uri.https(webDomain, '', {
      'secret_key': licenseVerificationKey,
      'slm_action': 'slm_deactivate',
      'license_key': licenseKey,
      'registered_domain': domain,
    });

    try {
      final response = await HttpUtils.httpGet(uri);

      final map =
          Map<String, dynamic>.from(json.decode(response.body) as Map? ?? {});

      return LicenseResponseModel.fromJson(map);
    } catch (err) {
      print('LicenseKeyServer deactivate err: $err');
    }

    return LicenseResponseModel.error();
  }

  Future<LicenseResponseModel> handleLostLicenseReq({
    required String email,
    required bool sendEmail,
  }) async {
    if (email.isNotEmpty) {
      final responseMap = await _postToRestApi(
        {
          'action': 'lost_license',
          'email': email,
          'sendEmail': sendEmail,
        },
      );

      return LicenseResponseModel.fromJson(responseMap);
    }

    return LicenseResponseModel.error();
  }

  // =================================================================

  Future<Map<String, dynamic>> _postToRestApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(restAPIUrl),
        body: json.encode(body),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json; charset=utf-8',
        },
      );

      final result = json.decode(response.body) as Map<String, dynamic>? ?? {};

      if (result['result'] == 'ok') {
        return result;
      }
    } catch (err) {
      print(err);
    }

    return {};
  }
}
