import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<Iterable<Map<String, dynamic>>?> importChatHistory(
  BuildContext context,
) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result != null && result.files.single.path != null) {
    File file = File(result.files.single.path!);
    try {
      String jsonData = await file.readAsString();
      List<dynamic> decoded = jsonDecode(jsonData);

      // Convert each message ensuring binary fields are cast to Uint8List if needed.
      final List<Map<String, dynamic>> messages =
          decoded.map<Map<String, dynamic>>((msg) {
        final Map<String, dynamic> message = Map<String, dynamic>.from(msg);
        if (message.containsKey('image') && message['image'] is List) {
          message['image'] =
              Uint8List.fromList(List<int>.from(message['image']));
        }
        return message;
      }).toList();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chat history imported successfully")),
      );
      return messages;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error importing chat history")),
      );
    }
  }
  return null;
}
