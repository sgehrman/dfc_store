import 'package:admin_app/dialogs/json_dialog.dart';
import 'package:admin_app/dialogs/shared/widget_dialog.dart';
import 'package:admin_app/prefs.dart';
import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:dfc_store/dfc_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showActivateDialog({
  required BuildContext context,
}) {
  return widgetDialog<List<String>>(
    context: context,
    dialogWidth: 700,
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [
        Flexible(
          child: SizedBox(
            height: 400,
            child: ActivateTab(keyboardNotifier),
          ),
        ),
      ],
    ),
    title: 'Activate',
  );
}

// ===============================================================

class _ActivationTable extends StatelessWidget {
  const _ActivationTable({
    required this.onChanged,
    required this.model,
    required this.machineId,
  });

  final void Function() onChanged;
  final LicenseKeyModel? model;
  final String machineId;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (model == null || model!.registeredDomains.isEmpty) {
      content = const NothingFound(
        message: 'No Activations',
      );
    } else {
      content = ListView.builder(
        itemCount: model!.registeredDomains.length,
        itemBuilder: (context, index) {
          final domain = model!.registeredDomains[index];

          return _DomainListItem(
            model: domain,
            highlight: domain.registeredDomain == machineId,
            onChanged: onChanged,
          );
        },
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(border: Border()),
      child: content,
    );
  }
}

// ================================================
class _LicenseKeyTextField extends StatelessWidget {
  const _LicenseKeyTextField({
    required this.textController,
    required this.onActivate,
    required this.isActivated,
  });

  final TextEditingController textController;
  final void Function() onActivate;
  final bool isActivated;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        isDense: true,
        hintText: 'License Key',
        suffix: DFTextButton(
          label: isActivated ? 'Deactivate' : 'Activate',
          onPressed: onActivate,
        ),
      ),
      onSubmitted: (v) => onActivate.call(),
      keyboardType: TextInputType.text,
      autofocus: true,
      textInputAction: TextInputAction.done,
      controller: textController,
    );
  }
}

// ======================================================

class _DomainListItem extends StatelessWidget {
  const _DomainListItem({
    required this.model,
    required this.onChanged,
    required this.highlight,
  });

  final RegisteredDomainModel model;
  final void Function() onChanged;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    TextStyle? style;

    if (highlight) {
      style = TextStyle(color: context.primary);
    }

    return ListTile(
      title: Text(
        model.registeredDomain,
        style: style,
      ),
      subtitle: Text(model.licKey),
      trailing: DFIconButton(
        tooltip: 'Deactivate',
        icon: const Icon(Icons.clear),
        onPressed: () async {
          final result = await ServerRestApi.deactivate(
            domain: model.registeredDomain,
            webDomain: Prefs.webDomain,
            licenseKey: model.licKey,
            licenseVerificationKey: Prefs.verifySecret,
          );

          print(result);

          onChanged();
        },
      ),
    );
  }
}

// ===================================================================

class ActivateTab extends StatefulWidget {
  const ActivateTab(
    this.keyboardNotifier,
  );

  final ValueNotifier<bool> keyboardNotifier;

  @override
  State<ActivateTab> createState() => ActivateTabState();
}

class ActivateTabState extends State<ActivateTab> {
  final _licenseKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _setup();
  }

  Future<void> _setup() async {
    // if not in prefs, see if the server has one
    // prioritize pref since they might not be logged in
    final String licenseKey = Prefs.licenseKey;

    _licenseKeyController.text = licenseKey;

    await _reloadLicenseKey();
  }

  bool _isActivated() {
    // final model = await ServerRestApi.check(
    //   licenseKey: _licenseKeyController.text,
    //   licenseVerificationKey: Prefs.verifySecret,
    //   webDomain: Prefs.webDomain,
    // );

    final model = _LicenseKeyModelCache.shared
        .get(licenseKey: _licenseKeyController.text);

    if (model != null) {
      return model.check(
        licenseKey: _licenseKeyController.text,
        machineId: Prefs.machineId,
      );
    }

    return false;
  }

  Future<void> _toggleActivation() async {
    final wasActivated = _isActivated();

    Prefs.licenseKey = _licenseKeyController.text;

    // once we load with the entered key, it might be activated now
    // that's why we check above, this toggle will get out of sync otherwise
    await _reloadLicenseKey();

    if (!wasActivated) {
      if (!_isActivated()) {
        await ServerRestApi.activate(
          licenseKey: _licenseKeyController.text,
          domain: Prefs.machineId,
          licenseVerificationKey: Prefs.verifySecret,
          webDomain: Prefs.webDomain,
        );

        if (_isActivated()) {
          Utils.successSnackbar(
            title: 'Success',
            message: 'Activated',
          );
        }
      }
    } else {
      final model = _LicenseKeyModelCache.shared.get(
        licenseKey: _licenseKeyController.text,
      );

      if (model != null) {
        await ServerRestApi.deactivate(
          webDomain: Prefs.webDomain,
          domain: Prefs.machineId,
          licenseKey: model.licenseKey,
          licenseVerificationKey: Prefs.verifySecret,
        );
      }
    }

    if (mounted) {
      await _reloadLicenseKey();

      setState(() {});
    }
  }

  Future<void> _reloadLicenseKey() async {
    final model = await ServerRestApi.check(
      licenseKey: _licenseKeyController.text,
      licenseVerificationKey: Prefs.verifySecret,
      webDomain: Prefs.webDomain,
    );

    _LicenseKeyModelCache.shared.set(model: model);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkIfActivated() async {
    await _reloadLicenseKey();

    if (_isActivated()) {
      Utils.successSnackbar(
        title: 'Success',
        message: 'Activated',
      );
    } else {
      Utils.successSnackbar(
        title: 'Error',
        message: 'Not Activated',
        error: true,
      );
    }
  }

  Widget _checkButton() {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        DFIconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            final model = _LicenseKeyModelCache.shared
                .get(licenseKey: _licenseKeyController.text);

            showJsonDialog(
              context: context,
              data: model?.toJson() ?? {},
              title: 'License Info',
            );
          },
        ),
        const SizedBox(width: 20),
        DFOutlineButton(
          label: 'Check',
          onPressed: _checkIfActivated,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final model = _LicenseKeyModelCache.shared.get(
      licenseKey: _licenseKeyController.text,
    );

    if (model == null) {
      return const NothingWidget();
    }

    final used = model.registeredDomains.length;
    final total = int.tryParse(model.maxAllowedDomains) ?? 0;

    final activations = '$used/$total';

    if (_isActivated()) {
      final expireDate = DateTime.tryParse(model.dateExpiry);
      String expiresString = '';
      if (expireDate != null) {
        final formatter = DateFormat('MM-dd-y');
        final dateString = formatter.format(expireDate);

        expiresString = 'Expires: $dateString';
      }
      children.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text22(
              'License Activated',
              color: context.primary,
            ),
            Text16(
              expiresString,
              bold: false,
            ),
          ],
        ),
      ]);
    } else {
      children.addAll([
        Text22(
          'Enter Your License Key And Click Activate',
        ),
      ]);

      if (model.isBlocked) {
        children.addAll([
          const SizedBox(height: 20),
          Text22(
            'License Blocked',
          ),
        ]);
      } else if (model.isExpired) {
        children.addAll([
          const SizedBox(height: 20),
          Text22(
            'License Expired',
          ),
        ]);
      }
    }

    children.addAll([
      const SizedBox(height: 20),
      _LicenseKeyTextField(
        textController: _licenseKeyController,
        onActivate: _toggleActivation,
        isActivated: _isActivated(),
      ),
      const SizedBox(height: 20),
      Text16('Machine ID'),
      Text(Prefs.machineId),
      const SizedBox(height: 20),
      Expanded(
        child: _ActivationTable(
          model: model,
          machineId: Prefs.machineId,
          onChanged: _reloadLicenseKey,
        ),
      ),
      const SizedBox(height: 8),
      Text16(
        'Activations $activations',
        bold: false,
      ),
    ]);

    if (_isActivated()) {
      children.addAll([
        const SizedBox(height: 20),
        _checkButton(),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

// ============================================================

class _LicenseKeyModelCache {
  _LicenseKeyModelCache._();

  static _LicenseKeyModelCache shared = _LicenseKeyModelCache._();

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
