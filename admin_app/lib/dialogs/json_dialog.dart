import 'package:admin_app/dialogs/widget_dialog.dart';
import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showJsonDialog({
  required BuildContext context,
  required String title,
  required Map<String, dynamic> data,
  Widget? additionalButton,
}) {
  final Widget copyButton = DFIconButton(
    tooltip: 'Copy JSON',
    onPressed: () {
      final String jsonStr = StrUtils.toPrettyString(data);
      Clipboard.setData(ClipboardData(text: jsonStr));

      Utils.showCopiedToast(context);
    },
    icon: const Icon(Icons.content_copy),
  );

  final titleButtons = [copyButton];
  if (additionalButton != null) {
    titleButtons.add(additionalButton);
  }

  return widgetDialog<List<String>>(
    context: context,
    titleButtons: titleButtons,
    builder: WidgetDialogContentBuilder(
      (keyboardNotifier, titleNotifier) => [
        JsonViewerWidget(
          data,
          convertIntsToDates: false,
        ),
      ],
    ),
    title: title,
  );
}
