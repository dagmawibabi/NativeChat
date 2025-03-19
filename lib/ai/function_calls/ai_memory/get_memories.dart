import 'package:hive_flutter/hive_flutter.dart';

Future<List> getMemories() async {
  Box memoryBox = await Hive.openBox("memories");

  // Get Old Memories
  var oldMemories = await memoryBox.get("memories") ?? [];

  // Close
  await memoryBox.close();

  // Return
  return oldMemories;
}
