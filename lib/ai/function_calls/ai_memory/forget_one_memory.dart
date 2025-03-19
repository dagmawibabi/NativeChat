// ignore_for_file: empty_catches

import 'package:hive_flutter/hive_flutter.dart';

Future<String> forgetOneMemory(memory) async {
  Box memoryBox = await Hive.openBox("memories");

  // Get OLD memories
  var oldMemories = await memoryBox.get("memories") ?? [];

  // Remove one memory
  try {
    oldMemories.remove(memory);
  } catch (e) {}

  // Save Updated Memory
  await memoryBox.put("memories", oldMemories);

  // Close
  await memoryBox.close();

  // Context
  var advancedContext = "YOU HAVE UPDATED YOUR MEMORIES.";

  // Return
  return advancedContext;
}
