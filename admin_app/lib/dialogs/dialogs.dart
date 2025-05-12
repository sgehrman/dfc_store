import 'package:admin_app/dialogs/activate_dialog_content.dart';
import 'package:admin_app/dialogs/creaste_dialog_content.dart';
import 'package:admin_app/dialogs/lost_license_dialog_content.dart';
import 'package:admin_app/dialogs/search_email_dialog_content.dart';
import 'package:admin_app/dialogs/search_license_dialog_content.dart';
import 'package:admin_app/dialogs/settingss_dialog_content.dart';
import 'package:admin_app/dialogs/shared/store_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showSearchLicenseDialog({required BuildContext context}) {
  return storeDialog(
    context: context,
    title: 'Search License',
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const SearchLicenseDialogContent()],
    ),
  );
}

Future<void> showSearchEmailDialog({required BuildContext context}) {
  return storeDialog(
    context: context,
    title: 'Search Email',
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const SearchEmailDialogContent()],
    ),
  );
}

Future<void> showLostLicenseDialog({required BuildContext context}) {
  return storeDialog<List<String>>(
    context: context,
    dialogWidth: 400,
    scrollable: false,
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const LostLicenseDialogContent()],
    ),
    title: 'Lost License',
  );
}

Future<void> showCreateDialog({required BuildContext context}) {
  return storeDialog(
    context: context,
    scrollable: false,
    title: 'Create License Key',
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const CreateDialogContent()],
    ),
  );
}

Future<void> showActivateDialog({required BuildContext context}) {
  return storeDialog<List<String>>(
    context: context,
    dialogWidth: 700,
    scrollable: false,
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const ActivateDialogContent()],
    ),
    title: 'Activate',
  );
}

Future<void> showSettingsDialog({required BuildContext context}) {
  return storeDialog(
    context: context,
    scrollable: false,
    title: 'Settings',
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [const SettingsDialogContent()],
    ),
  );
}
