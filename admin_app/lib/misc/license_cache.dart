import 'package:admin_app/misc/prefs.dart';
import 'package:dfc_store/dfc_store.dart';

class LicenseCache {
  LicenseCache._();

  static LicenseCache shared = LicenseCache._();

  final Map<String, LicenseKeyModel> _cache = {};

  void remove({required String licenseKey}) {
    _cache.remove(licenseKey);
  }

  LicenseKeyModel? get({required String licenseKey}) {
    return _cache[licenseKey];
  }

  void set({required LicenseKeyModel model}) {
    _cache[model.licenseKey] = model;
  }

  // =======================================================
  // urils

  static Future<void> loadLicenseKey(String licenseKey) async {
    // save license key pref here
    Prefs.licenseKey = licenseKey;

    final model = await ServerRestApi.check(
      licenseKey: licenseKey,
      licenseVerificationKey: Prefs.verifySecret,
      webDomain: Prefs.webDomain,
    );

    LicenseCache.shared.set(model: model);
  }
}
