import 'package:hive_flutter/hive_flutter.dart';

Future<String> forgetMemory() async {
  Box memoryBox = await Hive.openBox("memories");

  // Save Empty Memory
  await memoryBox.put("memories", []);

  // Close
  await memoryBox.close();

  // Context
  var advancedContext =
      "YOU HAVE REMOVED EVERYTHING YOU REMEMBERED ABOUT THE USER.";

  // Return
  return advancedContext;
}
