import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IsOneSidedChatModeNotifier {
  static final IsOneSidedChatModeNotifier _instance =
      IsOneSidedChatModeNotifier._internal();
  factory IsOneSidedChatModeNotifier() {
    return _instance;
  }
  IsOneSidedChatModeNotifier._internal();

  final ValueNotifier<bool> isOneSidedChatMode = ValueNotifier(true);

  // Is One Sided Chat Mode
  void getIsOneSidedMode() async {
    Box settingBox = await Hive.openBox("settings");
    isOneSidedChatMode.value =
        await settingBox.get("isOneSidedChatMode") ?? true;
    settingBox.close();
  }

  // Toggle One Sided Mode
  void toggle() async {
    isOneSidedChatMode.value = !isOneSidedChatMode.value;

    Box settingBox = await Hive.openBox("settings");
    await settingBox.put(
      "isOneSidedChatMode",
      isOneSidedChatMode.value,
    );
    settingBox.close();
  }

  // Dispose
  void dispose() {
    isOneSidedChatMode.dispose();
  }
}
