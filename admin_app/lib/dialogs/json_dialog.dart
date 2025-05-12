import 'package:admin_app/dialogs/shared/store_dialog.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

Future<void> showJsonDialog({
  required BuildContext context,
  required String title,
  required Map<String, dynamic> data,
  Widget? additionalButton,
}) {
  final Widget copyButton = DFIconButton(
    tooltip: 'Copy JSON',
    onPressed: () {
      final jsonStr = StrUtils.toPrettyString(data);

      Utils.copyToClipboard(jsonStr);
    },
    icon: const Icon(Icons.content_copy),
  );

  final titleButtons = [copyButton];
  if (additionalButton != null) {
    titleButtons.add(additionalButton);
  }

  return storeDialog<List<String>>(
    context: context,
    titleButtons: titleButtons,
    builder: AdminDialogContentBuilder(
      (keyboardNotifier) => [JsonViewerWidget(data, convertIntsToDates: false)],
    ),
    title: title,
  );
}
