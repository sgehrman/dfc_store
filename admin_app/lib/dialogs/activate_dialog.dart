import 'package:admin_app/dialogs/json_dialog.dart';
import 'package:admin_app/dialogs/shared/widget_dialog.dart';
import 'package:admin_app/misc/prefs.dart';
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
    scrollable: false,
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [
        Flexible(
          child: SizedBox(
            height: 1000,
            child: ActivateTab(keyboardNotifier),
          ),
        ),
      ],
    ),
    title: 'Activate',
  );
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
  final _emailController = TextEditingController();

  late LicenseKeyManager _keyMgr;

  @override
  void initState() {
    super.initState();

    _licenseKeyController.text = Prefs.licenseKey;
    _emailController.text = Prefs.email;

    _keyMgr = LicenseKeyManager(
      () {
        final result = LicenseManagerParams(
          useEmail: true,
          verifySecret: Prefs.verifySecret,
          machineId: Prefs.machineId,
          licenseKey: _licenseKeyController.text,
          webDomain: Prefs.webDomain,
          email: _emailController.text,
        );

        // save prefs here
        Prefs.licenseKey = result.licenseKey;
        Prefs.email = result.email;

        return result;
      },
    );

    _setup();
  }

  Future<void> _setup() async {
    await _keyMgr.loadModel();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _activate({required bool activate}) async {
    final success = await _keyMgr.activate(
      activate: activate,
      machineId: Prefs.machineId,
    );

    if (success) {
      Utils.successSnackbar(
        title: 'Success',
        message: activate ? 'Activated' : 'Deactivated',
      );

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _checkIfActivated() async {
    await _keyMgr.isActivatedAsync();

    if (_keyMgr.isActivated()) {
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
            final model = _keyMgr.currentModel();

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
    final model = _keyMgr.currentModel();

    if (model == null) {
      return const NothingWidget();
    }

    final used = model.registeredDomains.length;
    final total = int.tryParse(model.maxAllowedDomains) ?? 0;

    final activations = '$used/$total';

    if (_keyMgr.isActivated()) {
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

    final isActivated = _keyMgr.isActivated();

    children.addAll([
      const SizedBox(height: 20),
      _LicenseKeyTextField(
        textController: _licenseKeyController,
      ),
      const SizedBox(height: 10),
      _EmailTextField(textController: _emailController),
      const SizedBox(height: 20),
      DFTextButton(
        label: isActivated ? 'Deactivate' : 'Activate',
        onPressed: () => _activate(activate: !isActivated),
      ),
      const SizedBox(height: 20),
      Text16('Machine ID'),
      Text(Prefs.machineId),
      const SizedBox(height: 20),
      Expanded(
        child: _ActivationTable(
          model: model,
          machineId: Prefs.machineId,
          onDeactivate: (domain) async {
            await _keyMgr.activate(
              activate: false,
              machineId: domain,
            );

            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),
      const SizedBox(height: 8),
      Text16(
        'Activations $activations',
        bold: false,
      ),
      const SizedBox(height: 20),
      _checkButton(),
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

// ===============================================================

class _ActivationTable extends StatelessWidget {
  const _ActivationTable({
    required this.onDeactivate,
    required this.model,
    required this.machineId,
  });

  final void Function(String registeredDomain) onDeactivate;
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
            onDeactivate: onDeactivate,
          );
        },
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide()),
      ),
      child: content,
    );
  }
}

// ================================================
class _LicenseKeyTextField extends StatelessWidget {
  const _LicenseKeyTextField({
    required this.textController,
  });

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        isDense: true,
        hintText: 'License Key',
      ),
      keyboardType: TextInputType.text,
      autofocus: true,
      textInputAction: TextInputAction.done,
      controller: textController,
    );
  }
}

// ================================================

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
    required this.textController,
  });

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        isDense: true,
        hintText: 'Email',
      ),
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
    required this.onDeactivate,
    required this.highlight,
  });

  final RegisteredDomainModel model;
  final void Function(String registeredDomain) onDeactivate;
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
          onDeactivate(model.registeredDomain);
        },
      ),
    );
  }
}
