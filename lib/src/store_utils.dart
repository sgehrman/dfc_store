import 'package:flutter/services.dart';

class StoreUtils {
  StoreUtils._();

  // used internally to show the styling tools, and remove blur from dialogs
  static bool showStylingTools = false;

  // The websites have a hidden method of bringing up the admin panel
  static bool get isAdminKeysPressed =>
      HardwareKeyboard.instance.logicalKeysPressed
          .containsAll(<LogicalKeyboardKey>[
        LogicalKeyboardKey.shiftLeft,
        LogicalKeyboardKey.altLeft,
      ]);
}
