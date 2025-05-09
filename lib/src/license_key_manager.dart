import 'package:dfc_store/src/models/license_key_model.dart';
import 'package:dfc_store/src/models/license_response_model.dart';
import 'package:dfc_store/src/server_rest_api.dart';

class LicenseManagerParams {
  LicenseManagerParams({
    required this.useEmail,
    required this.verifySecret,
    required this.machineId,
    required this.licenseKey,
    required this.webDomain,
    required this.email,
  });

  bool useEmail;

  String verifySecret;
  String machineId;
  String licenseKey;
  String email;
  String webDomain;

  bool get isValid {
    return verifySecret.isNotEmpty &&
        licenseKey.isNotEmpty &&
        webDomain.isNotEmpty &&
        machineId.isNotEmpty;
  }
}

// ==============================================

class LicenseKeyManager {
  LicenseKeyManager(this.onParams);

  final LicenseManagerParams Function() onParams;

  LicenseManagerParams _params = LicenseManagerParams(
    email: '',
    licenseKey: '',
    webDomain: '',
    machineId: '',
    useEmail: false,
    verifySecret: '',
  );

  // --------------------------------------
  // utils

  LicenseKeyModel? currentModel() {
    if (paramsOK) {
      return _cacheGet(licenseKey: _params.licenseKey);
    }

    return null;
  }

  Future<LicenseKeyModel?> currentModelAsync() async {
    if (paramsOK) {
      final result = _cacheGet(licenseKey: _params.licenseKey);
      if (result == null) {
        await loadModel();
      }

      return _cacheGet(licenseKey: _params.licenseKey);
    }

    return null;
  }

  // get fresh copy of model
  // ### should we just confirm first if our models email/license keys match?
  Future<bool> isActivatedAsync() async {
    await loadModel();

    return isActivated(machineId: _params.machineId);
  }

  // machineId is to ask anther machine's activation is activated (when deactiting in the list)
  bool isActivated({String machineId = ''}) {
    final model = currentModel();

    if (model != null) {
      return model.check(
        licenseKey: _params.licenseKey,
        email: _params.useEmail ? _params.email : '',
        machineId: machineId.isNotEmpty ? machineId : _params.machineId,
      );
    }

    return false;
  }

  Future<LicenseKeyModel?> loadModel() async {
    if (paramsOK) {
      final model = await ServerRestApi.loadModel(
        licenseKey: _params.licenseKey,
        licenseVerificationKey: _params.verifySecret,
        webDomain: _params.webDomain,
      );

      if (model.isError) {
        print(model.message);
      } else {
        _cacheSet(model: model);
      }

      return model;
    }

    return null;
  }

  Future<LicenseResponseModel> activate({
    required bool activate,
    required String machineId,
  }) async {
    // this will load the model if null, so call this before isActivated()
    // user could have typed a new license key and we haven't loaded that model yet
    final model = await currentModelAsync();

    // could have a sitution where the user just puts in their email/license
    // and the button says activate, but this would deactiate them if they hit the button
    if (model != null) {
      if (activate != isActivated(machineId: machineId)) {
        var modelOK = false;

        // check to see if emails match before trying (if we care about emails)
        if (_params.useEmail) {
          modelOK = model.verifyLicenseAndEmail(
            licenseKey: _params.licenseKey,
            email: _params.email,
          );
        }

        if (modelOK) {
          LicenseResponseModel result;

          if (!isActivated(machineId: machineId)) {
            result = await ServerRestApi.activate(
              licenseKey: _params.licenseKey,
              domain: machineId,
              licenseVerificationKey: _params.verifySecret,
              webDomain: _params.webDomain,
            );

            await loadModel();
          } else {
            result = await ServerRestApi.deactivate(
              webDomain: _params.webDomain,
              domain: machineId,
              licenseKey: model.licenseKey,
              licenseVerificationKey: _params.verifySecret,
            );

            await loadModel();
          }

          return result;
        }
      }
    }

    return LicenseResponseModel.error();
  }

  // --------------------------------------
  // private

  bool get paramsOK {
    _params = onParams();

    return _params.isValid;
  }

  // --------------------------------------
  // cache

  final Map<String, LicenseKeyModel> _cache = {};

  LicenseKeyModel? _cacheGet({required String licenseKey}) {
    return _cache[licenseKey];
  }

  void _cacheSet({required LicenseKeyModel model}) {
    _cache[model.licenseKey] = model;
  }
}
