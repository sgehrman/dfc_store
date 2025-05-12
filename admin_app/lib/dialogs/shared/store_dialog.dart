import 'package:admin_app/dialogs/shared/store_dialog_base.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

Future<T?> storeDialog<T>({
  required BuildContext context,
  required String title,
  required AdminDialogContentBuilder builder,
  double dialogWidth = 500,
  bool scrollable = true,
  List<Widget> titleButtons = const [],
  EdgeInsetsGeometry padding = const EdgeInsets.all(20),
}) {
  return Navigator.of(context).push(
    _WidgetDialogRoute<T>(
      title: title,
      dialogWidth: dialogWidth,
      builder: builder,
      scrollable: scrollable,
      titleButtons: titleButtons,
      padding: padding,
    ),
  );
}

class AdminDialogContentBuilder {
  const AdminDialogContentBuilder(this.builder);

  final List<Widget> Function(ValueNotifier<bool> keyboardNotifier) builder;
}

// ======================================================

class _WidgetDialogWidget extends StatefulWidget {
  const _WidgetDialogWidget({
    required this.children,
    required this.scrollable,
    required this.padding,
  });

  final List<Widget> children;
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  @override
  State<_WidgetDialogWidget> createState() => _WidgetDialogWidgetState();
}

class _WidgetDialogWidgetState extends State<_WidgetDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.children,
    );

    if (widget.scrollable) {
      return SingleChildScrollView(padding: widget.padding, child: child);
    }

    return Padding(padding: widget.padding, child: child);
  }
}

// ======================================================

class _WidgetDialogRoute<T> extends StoreDialogRoute<T> {
  _WidgetDialogRoute({
    required this.title,
    required this.dialogWidth,
    required this.scrollable,
    required this.builder,
    required this.padding,
    this.titleButtons = const [],
  });

  final String title;
  final double dialogWidth;
  final AdminDialogContentBuilder builder;
  final bool scrollable;
  final List<Widget> titleButtons;
  final EdgeInsetsGeometry padding;

  @override
  Widget dialogWidget(
    BuildContext context,
    ValueNotifier<bool> keyboardNotifier,
  ) {
    return _WidgetDialogWidget(
      scrollable: scrollable,
      padding: padding,
      children: builder.builder(keyboardNotifier),
    );
  }

  @override
  double width() {
    return dialogWidth;
  }

  @override
  Widget titleButton({required BuildContext context, required bool isMobile}) {
    final closeButton = super.titleButton(context: context, isMobile: isMobile);
    final children = [...titleButtons, closeButton];

    children.addDividers(divider: const SizedBox(width: 10));

    return Row(children: children);
  }

  @override
  String dialogTitle() {
    return title;
  }
}
