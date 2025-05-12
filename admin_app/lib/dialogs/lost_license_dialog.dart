import 'package:admin_app/dialogs/shared/store_dialog.dart';
import 'package:admin_app/misc/store_prefs.dart';
import 'package:dfc_store/dfc_store.dart';
import 'package:flutter/material.dart';

Future<void> showLostLicenseDialog({required BuildContext context}) {
  return storeDialog<List<String>>(
    context: context,
    dialogWidth: 400,
    scrollable: false,
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const _LostLicenseDialogContent()],
    ),
    title: 'Lost License',
  );
}

class _LostLicenseDialogContent extends StatelessWidget {
  const _LostLicenseDialogContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Lost License'),
        LostLicenseForm(
          restUrl: StorePrefs.webStoreDomain.restUrl,
          isMobile: false,
        ),
      ],
    );
  }
}
