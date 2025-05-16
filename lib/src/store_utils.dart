import 'package:flutter/services.dart';

class StoreUtils {
  // The websites have a hidden method of bringing up the admin panel
  static bool get isAdminKeysPressed => HardwareKeyboard
      .instance
      .logicalKeysPressed
      .containsAll(<LogicalKeyboardKey>[
        LogicalKeyboardKey.shiftLeft,
        LogicalKeyboardKey.controlLeft,
      ]);
}
