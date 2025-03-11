import 'package:hive_flutter/hive_flutter.dart';

// dynamic isOneSidedChatMode = true;
void toggleOneSidedChatMode(isOneSidedChatMode) async {
  Box settingBox = await Hive.openBox("settings");
  isOneSidedChatMode = await settingBox.get("isOneSidedChatMode") ?? true;

  isOneSidedChatMode = !isOneSidedChatMode;
  // setState(() {
  // });
  await settingBox.put("isOneSidedChatMode", isOneSidedChatMode);
  settingBox.close();
}
