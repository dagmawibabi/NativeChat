import 'dart:convert';
import 'dart:io';

import 'package:nativechat/models/chat_session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportChatHistory(ChatSessionModel session) async {
  // Convert the session messages to a JSON string.
  final String jsonData = jsonEncode(session.messages);

  // Get the documents directory.
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath =
      '${directory.path}/chat_history_${DateTime.now().millisecondsSinceEpoch}.json';

  // Write the JSON data into the file.
  final File file = File(filePath);
  await file.writeAsString(jsonData);

  // Share the file using share_plus pkg.
  await Share.shareXFiles([XFile(filePath)], text: 'Exported Chat History');
}
