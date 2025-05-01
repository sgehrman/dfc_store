import 'dart:async';
import 'dart:convert';

import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:dfc_store/src/models/license_key_model.dart';
import 'package:dfc_store/src/models/license_response_model.dart';
import 'package:http/http.dart' as http;

class ServerRestApi {
  // flutter: {"result":"error","message":"Invalid license key","error_code":60}
  static Future<LicenseKeyModel> loadModel({
    required String licenseVerificationKey,
    required String webDomain,
    required String licenseKey,
  }) async {
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
  static Future<LicenseResponseModel> activate({
    required String webDomain,
    required String licenseVerificationKey,
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
  static Future<LicenseResponseModel> deactivate({
    required String webDomain,
    required String licenseVerificationKey,
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

  static Future<Map<String, dynamic>> postToRestApi(
    String restUrl,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(restUrl),
        body: json.encode(body),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json; charset=utf-8',
        },
      );

      final result = json.decode(response.body) as Map<String, dynamic>? ?? {};

      // TODO(SNG): need to display errors, this is bad
      if (result['result'] == 'ok') {
        return result;
      }
    } catch (err) {
      print(err);
    }

    return {};
  }

  static Future<List<String>> youTubeVideoIds(String restUrl) async {
    final response = await postToRestApi(
      restUrl,
      {
        'action': 'youtube_video_ids',
      },
    );

    final videoIdsString = response['videoIds'] as String? ?? '';
    final videoIds = videoIdsString.split(',');

    return videoIds.map((element) => element.trim()).toList();
  }

  static Future<ServerOptions> handleGetOptions(String restUrl) async {
    final response = await postToRestApi(
      restUrl,
      {
        'action': 'options',
      },
    );

    if (response['result'] == 'ok') {
      final options = response['options'] as Map<String, dynamic>? ?? {};

      if (options.isNotEmpty) {
        return ServerOptions(
          bannerCoupon: options['bannerCoupon'] as String? ?? '',
          bannerDiscount: options['bannerDiscount'] as String? ?? '',
          bannerEnabled: options['bannerEnabled'] as String? ?? '',
        );
      }
    }

    return ServerOptions(
      bannerCoupon: '',
      bannerDiscount: '',
      bannerEnabled: '',
    );
  }

  static Future<bool> subscribeToNewsletter({
    required String restUrl,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isNotEmpty) {
      try {
        final response = await postToRestApi(
          restUrl,
          {
            'action': 'subscribe_to_newsletter',
            'email': trimmedEmail,
            'firstName': firstName.trim(),
            'lastName': lastName.trim(),
          },
        );

        print('subscribeToNewsletter $response');

        return true;
      } catch (err) {
        print('ERROR: subscribeToNewsletter $err');
      }
    } else {
      print('subscribeToNewsletter email empty');
    }

    return false;
  }

  static Future<bool> emailSupport({
    required String restUrl,
    required String name,
    required String email,
    required String emailUsedToPurchase,
    required String subject,
    required String message,
    required String store,
    required String macOS,
    required String issue,
    required String purchaseDate,
    required String version,
  }) async {
    try {
      final contents = 'SUBJECT:\n$subject\n\n'
          'MESSAGE:\n$message\n\n'
          'ISSUE:\n$issue\n\n'
          'NAME:\n$name\n\n'
          'FROM:\n$email\n\n'
          'PURCHASE_EMAIL:\n$emailUsedToPurchase\n\n'
          'STORE:\n$store\n\n'
          'MACOS:\n$macOS\n\n'
          'VERSION:\n$version\n\n'
          'DATE:\n$purchaseDate\n\n';

      if (Utils.debugBuild) {
        print(contents);

        return true;
      } else {
        final response = await postToRestApi(
          restUrl,
          {
            'action': 'email_support',
            'message': contents,
            'subject': '${issue.toUpperCase()}: $subject',
          },
        );

        if (response['result'] == 'ok') {
          return true;
        }
      }
    } catch (err) {
      print('ERROR: emailSupport $err');
    }

    return false;
  }

  static Future<bool> sendLicenseKey({
    required String restUrl,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isNotEmpty) {
      try {
        final response = await postToRestApi(
          restUrl,
          {
            'action': 'create',
            'email': trimmedEmail,
            'firstName': firstName.trim(),
            'lastName': lastName.trim(),
            'password': password.trim(),
            'numUsers': 1,
          },
        );

        // flutter: {result: ok, message: , error_code: 0, license_key: PFK_6750ed7832c76, email: milke@cocoatech.com}

        print(response);

        if (response['result'] == 'ok') {
          return true;
        }
      } catch (err) {
        print('ERROR: sendLicenseKey $err');
      }
    } else {
      print('sendLicenseKey email empty');
    }

    return false;
  }

  static Future<LicenseResponseModel> requestLostLicense({
    required String restUrl,
    required String email,
    required bool sendEmail,
  }) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isNotEmpty) {
      try {
        final responseMap = await postToRestApi(
          restUrl,
          {
            'action': 'lost_license',
            'email': trimmedEmail,
            'sendEmail': sendEmail,
          },
        );

        return LicenseResponseModel.fromJson(responseMap);
      } catch (err) {
        print('ERROR: requestLostLicense $err');
      }
    } else {
      print('requestLostLicense email empty');
    }

    return LicenseResponseModel.error();
  }
}

// ================================================================

class ServerOptions {
  ServerOptions({
    required this.bannerEnabled,
    required this.bannerCoupon,
    required this.bannerDiscount,
  });

  String bannerEnabled;
  String bannerCoupon;
  String bannerDiscount;

  bool get isBannerEnabled {
    return bannerEnabled == '1' &&
        bannerCoupon.isNotEmpty &&
        bannerDiscount.isNotEmpty;
  }

  @override
  String toString() {
    return 'bannerEnabled: $bannerEnabled, bannerCoupon: $bannerCoupon, bannerDiscount: $bannerDiscount';
  }
}
