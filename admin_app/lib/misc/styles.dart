import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class Styles {
  static const double moduleBoxRadius = 20;

  static Color dialogTitlebarColor(BuildContext context) {
    return context.primary;
  }

  static List<BoxShadow> dialogShadows(BuildContext context) {
    return [
      BoxShadow(
        color: Utils.isDarkMode(context) ? Colors.black : Colors.black54,
        // offset: const Offset(0, 2),
        blurRadius: 44,
        spreadRadius: -12,
        // blurStyle: BlurStyle.outer,
      ),
    ];
  }
}
