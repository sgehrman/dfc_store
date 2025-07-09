import 'package:flutter/services.dart';

class StoreUtils {
  StoreUtils._();

  static bool showStylingTools = false;

  // The websites have a hidden method of bringing up the admin panel
  static bool get isAdminKeysPressed =>
      HardwareKeyboard.instance.logicalKeysPressed
          .containsAll(<LogicalKeyboardKey>[
        LogicalKeyboardKey.shiftLeft,
        LogicalKeyboardKey.altLeft,
      ]);

  static bool get isStyleKeysPressed =>
      HardwareKeyboard.instance.logicalKeysPressed
          .containsAll(<LogicalKeyboardKey>[
        LogicalKeyboardKey.shiftRight,
        LogicalKeyboardKey.altLeft,
      ]);
}
