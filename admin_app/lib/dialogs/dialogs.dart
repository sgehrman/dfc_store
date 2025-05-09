import 'package:admin_app/dialogs/activate_dialog_content.dart';
import 'package:admin_app/dialogs/creaste_dialog_content.dart';
import 'package:admin_app/dialogs/lost_license_dialog_content.dart';
import 'package:admin_app/dialogs/search_email_dialog_content.dart';
import 'package:admin_app/dialogs/search_license_dialog_content.dart';
import 'package:admin_app/dialogs/settingss_dialog_content.dart';
import 'package:admin_app/dialogs/shared/widget_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showSearchLicenseDialog({required BuildContext context}) {
  return widgetDialog(
    context: context,
    title: 'Search License',
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [const SearchLicenseDialogContent()],
    ),
  );
}

Future<void> showSearchEmailDialog({required BuildContext context}) {
  return widgetDialog(
    context: context,
    title: 'Search Email',
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [const SearchEmailDialogContent()],
    ),
  );
}

Future<void> showLostLicenseDialog({required BuildContext context}) {
  return widgetDialog<List<String>>(
    context: context,
    dialogWidth: 400,
    scrollable: false,
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [const LostLicenseDialogContent()],
    ),
    title: 'Lost License',
  );
}

Future<void> showCreateDialog({required BuildContext context}) {
  return widgetDialog(
    context: context,
    scrollable: false,
    title: 'Create License Key',
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [const CreateDialogContent()],
    ),
  );
}

Future<void> showActivateDialog({required BuildContext context}) {
  return widgetDialog<List<String>>(
    context: context,
    dialogWidth: 700,
    scrollable: false,
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [const ActivateDialogContent()],
    ),
    title: 'Activate',
  );
}

Future<void> showSettingsDialog({required BuildContext context}) {
  return widgetDialog(
    context: context,
    scrollable: false,
    title: 'Settings',
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [const SettingsDialogContent()],
    ),
  );
}
