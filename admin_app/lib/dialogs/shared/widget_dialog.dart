import 'package:admin_app/dialogs/shared/dialog_base.dart';
import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

Future<T?> widgetDialog<T>({
  required BuildContext context,
  required String title,
  required WidgetDialogContentBuilder builder,
  double dialogWidth = 500,
  bool scrollable = true,
  List<Widget> titleButtons = const [],
  EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  DialogBackButtonController? backButtonController,
  bool centerDialog = true,
}) {
  return Navigator.of(context).push(
    _WidgetDialogRoute<T>(
      title: title,
      dialogWidth: dialogWidth,
      builder: builder,
      scrollable: scrollable,
      titleButtons: titleButtons,
      padding: padding,
      centerDialog: centerDialog,
      backButtonController: backButtonController,
    ),
  );
}

class WidgetDialogContentBuilder {
  const WidgetDialogContentBuilder(this.builder);

  final List<Widget> Function(
    ValueNotifier<bool> keyboardNotifier,
    ValueNotifier<String> titleNotifier,
  ) builder;
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
      return SingleChildScrollView(
        padding: widget.padding,
        child: child,
      );
    }

    return Padding(
      padding: widget.padding,
      child: child,
    );
  }
}

// ======================================================

class _WidgetDialogRoute<T> extends BaseDialogRoute<T> {
  _WidgetDialogRoute({
    required this.title,
    required this.dialogWidth,
    required this.scrollable,
    required this.builder,
    required this.padding,
    this.titleButtons = const [],
    this.centerDialog = true,
    this.backButtonController,
  });

  final String title;
  final double dialogWidth;
  final WidgetDialogContentBuilder builder;
  final bool scrollable;
  final List<Widget> titleButtons;
  final bool centerDialog;
  final EdgeInsetsGeometry padding;
  final DialogBackButtonController? backButtonController;

  @override
  Widget dialogWidget(
    BuildContext context,
    ValueNotifier<bool> keyboardNotifier,
    ValueNotifier<String> titleNotifier,
  ) {
    return _WidgetDialogWidget(
      scrollable: scrollable,
      padding: padding,
      children: builder.builder(
        keyboardNotifier,
        titleNotifier,
      ),
    );
  }

  @override
  double width() {
    return dialogWidth;
  }

  @override
  Widget titleButton({
    required BuildContext context,
    required bool isMobile,
  }) {
    final closeButton = super.titleButton(
      context: context,
      isMobile: isMobile,
    );
    final children = [...titleButtons, closeButton];

    children.addDividers(divider: const SizedBox(width: 10));

    return Row(children: children);
  }

  @override
  String dialogTitle() {
    return title;
  }

  @override
  bool centered() {
    return centerDialog;
  }

  @override
  Widget titleBackButton(
    BuildContext context,
  ) {
    if (backButtonController != null) {
      return DialogBackButton(
        controller: backButtonController!,
      );
    }

    return super.titleBackButton(context);
  }
}
