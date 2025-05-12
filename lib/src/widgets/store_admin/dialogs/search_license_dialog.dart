import 'package:dfc_flutter/dfc_flutter_web_lite.dart' hide FormBuilder;
import 'package:dfc_store/dfc_store.dart';
import 'package:dfc_store/src/widgets/store_admin/dialogs/shared/store_dialog.dart';
import 'package:dfc_store/src/widgets/store_admin/misc/store_prefs.dart';
import 'package:flutter/material.dart';

Future<void> showSearchLicenseDialog({required BuildContext context}) {
  return storeDialog(
    context: context,
    title: 'Search License',
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const _SearchLicenseDialogContent()],
    ),
  );
}

// =================================================================

class _SearchLicenseDialogContent extends StatelessWidget {
  const _SearchLicenseDialogContent();

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SizedBox(height: 500, child: _AdminWidget(isMobile: false)),
    );
  }
}
// =================================================================

class _AdminWidget extends StatefulWidget {
  const _AdminWidget({required this.isMobile});

  final bool isMobile;

  @override
  State<_AdminWidget> createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<_AdminWidget> {
  String _output = '';
  final _licenseKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _licenseKeyController.text = StorePrefs.licenseKey;
  }

  Future<void> _onSubmit(String license) async {
    StorePrefs.licenseKey = license;

    // final result = await ServerRestApi.searchEmail(
    final result = await ServerRestApi.searchLicense(
      restUrl: StorePrefs.webStoreDomain.restUrl,
      licenseKey: license,
      password: StorePrefs.apiPassword(StorePrefs.webStoreDomain),
    );

    if (result.isNotEmpty) {
      _output = StrUtils.toPrettyString(result);

      if (mounted) {
        setState(() {});
      }

      Utils.successSnackbar(title: 'Success', message: 'Search complete');
    } else {
      Utils.successSnackbar(
        title: 'Error',
        message: 'Something went wrong',
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            TextField(
              controller: _licenseKeyController,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'License Key',
              ),
              keyboardType: TextInputType.text,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: _onSubmit,
            ),

            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () => _onSubmit(_licenseKeyController.text),
              mini: true,
              child: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            color: context.surfaceContainerHigh,
            padding: const EdgeInsets.all(20),
            child: SelectableText(_output),
          ),
        ),
      ],
    );
  }
}
