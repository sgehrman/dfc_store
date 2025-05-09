import 'package:admin_app/dialogs/shared/widget_dialog.dart';
import 'package:admin_app/misc/prefs.dart';
import 'package:dfc_store/dfc_store.dart';
import 'package:flutter/material.dart';

Future<void> showLostLicenseDialog({required BuildContext context}) {
  return widgetDialog<List<String>>(
    context: context,
    dialogWidth: 400,
    scrollable: false,
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [
        const Text('Lost License'),
        LostLicenseForm(restUrl: Prefs.webStoreDomain.restUrl, isMobile: false),
      ],
    ),
    title: 'Activate',
  );
}
