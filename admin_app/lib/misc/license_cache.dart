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
}
