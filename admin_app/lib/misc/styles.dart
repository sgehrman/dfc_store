import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class Styles {
  static Color primaryFixedDim(BuildContext context) =>
      Theme.of(context).colorScheme.primaryFixedDim;
  static Color accent(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  // const Color.fromARGB(255, 255, 83, 140);
  static Color appBar(BuildContext context) =>
      const Color.fromRGBO(30, 30, 30, 1);

  static List<BoxShadow> heroShadow(BuildContext context) => [
    const BoxShadow(blurRadius: 24),
  ];

  static const black = Colors.black87;

  static Color scaffold(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static final greyLight = Colors.grey[100];

  static const lightTextOpacity = 0.8;

  static double contentPaddingWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 1350) {
      return 20;
    }

    if (width > 2200) {
      return width * 0.25;
    }

    return width * 0.15;
  }

  static EdgeInsets contentPadding(
    BuildContext context, {
    double top = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: contentPaddingWidth(context),
      right: contentPaddingWidth(context),
      top: top,
      bottom: bottom,
    );
  }

  static EdgeInsets contentSidePadding(
    BuildContext context, {
    double vertical = 0,
    bool left = true,
  }) {
    return EdgeInsets.only(
      left: left ? contentPaddingWidth(context) : 0,
      right: !left ? contentPaddingWidth(context) : 0,
      top: vertical,
      bottom: vertical,
    );
  }

  static Color lightPrimary(BuildContext context, {double opacity = 0.4}) =>
      Theme.of(context).colorScheme.primary.withValues(alpha: opacity);

  static Color dimTextColor(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5);

  static const spaceBetweenButtons = 20.0;

  static Color sidebarIconColor({
    required BuildContext context,
    required bool active,
  }) {
    final dark = Utils.isDarkMode(context);
    var activeColor = context.primary;
    var inactiveColor = Colors.black87;

    if (dark) {
      activeColor = context.primary;
      inactiveColor = Colors.white60;
    }

    if (active) {
      return activeColor;
    }

    return inactiveColor;
  }

  static const listPadding = EdgeInsets.symmetric(vertical: 10);

  static const double moduleBoxRadius = 20;
  static const double moduleBoxRadiusAlt = 6;

  static Color dialogTitlebarColor(BuildContext context) {
    return context.primary;
  }

  // use a ListDecoration widget
  static BoxDecoration listDecoration(
    BuildContext context, {
    bool addBorder = true,
  }) {
    final dark = Utils.isDarkMode(context);

    return BoxDecoration(
      color: dark ? const Color.fromRGBO(60, 60, 60, 1) : context.lightPrimary,
      borderRadius:
          addBorder ? const BorderRadius.all(Radius.circular(12)) : null,
      border: addBorder ? Border.all(color: borderColor(context)) : null,
    );
  }

  static List<BoxShadow> shadows(BuildContext context) {
    final dark = Utils.isDarkMode(context);

    return [
      BoxShadow(color: dark ? Colors.black38 : Colors.black26, blurRadius: 20),
    ];
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

  static Color borderColor(BuildContext context) {
    return Theme.of(context).dividerColor;
  }
}

// ====================================================

class ButtonSpacer extends StatelessWidget {
  const ButtonSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: Styles.spaceBetweenButtons);
  }
}
