import 'dart:math' as math;
import 'dart:ui';

import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class StoreDialogRoute<T> extends ModalRoute<T> {
  StoreDialogRoute() : super(filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3));

  final _keyboardNotifier = ValueNotifier<bool>(false);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withValues(alpha: 0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _buildPage(
      context: context,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      isMobile: false,
    );
  }

  Widget _buildPage({
    required BuildContext context,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required bool isMobile,
  }) {
    final screenSize = MediaQuery.of(context).size;

    final dialogShadows = [
      BoxShadow(
        color: Utils.isDarkMode(context) ? Colors.black : Colors.black54,
        // offset: const Offset(0, 2),
        blurRadius: 44,
        spreadRadius: -12,
        // blurStyle: BlurStyle.outer,
      ),
    ];

    final contents = Container(
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.9,
        maxWidth: screenSize.width * 0.9,
      ),
      width: math.min(screenSize.width * 0.9, width()),
      decoration: BoxDecoration(
        color: context.dialogBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: dialogShadows,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(
              title: dialogTitle(),
              titleButton: titleButton(context: context, isMobile: isMobile),
              isMobile: isMobile,
            ),
            Flexible(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: dialogWidget(context, _keyboardNotifier),
              ),
            ),
          ],
        ),
      ),
    );

    return Center(child: contents);
  }

  // override
  Widget dialogWidget(
    BuildContext context,
    ValueNotifier<bool> keyboardNotifier,
  ) {
    return const Text('must override');
  }

  // override
  String dialogTitle() {
    return '';
  }

  // override to replace the close button
  Widget titleButton({required BuildContext context, required bool isMobile}) {
    return DFIconButton(
      tooltip: 'Close',
      iconSize: isMobile ? 24 : 30,
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.clear),
    );
  }

  // override
  double width() {
    return 600;
  }
}

// ==========================================================
//      final title = dialogTitle();

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.title,
    required this.titleButton,
    required this.isMobile,
  });

  final String title;
  final Widget titleButton;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                isMobile
                    ? Text16(title, color: context.onPrimary)
                    : Text20(title, color: context.onPrimary, bold: false),
          ),
          titleButton,
        ],
      ),
    );
  }
}
