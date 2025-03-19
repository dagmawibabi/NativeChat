import 'package:hive_flutter/hive_flutter.dart';

Future<void> saveMemory(memory) async {
  Box memoryBox = await Hive.openBox("memories");

  // Get Old Memories
  var oldMemories = await memoryBox.get("memories") ?? [];

  // Save New Memory
  var newMemories = [...oldMemories, memory];
  await memoryBox.put("memories", newMemories);

  // Close
  await memoryBox.close();
}
