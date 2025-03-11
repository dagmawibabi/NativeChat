// dart
// File: lib/components/chat_image_container.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nativechat/state/is_one_sided_chat_mode_notifier.dart';
import 'package:nativechat/utils/open_image_fullscreen.dart';

class ChatImageContainer extends StatefulWidget {
  const ChatImageContainer({
    super.key,
    required this.image,
  });

  final Uint8List image;

  @override
  State<ChatImageContainer> createState() => _ChatImageContainerState();
}

class _ChatImageContainerState extends State<ChatImageContainer> {
  var isOneSidedChatModeNotifier = IsOneSidedChatModeNotifier();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isOneSidedChatModeNotifier.isOneSidedChatMode,
      builder: (context, value, child) {
        return Align(
          alignment: value ? Alignment.centerLeft : Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: SizedBox(
              height: 150.0,
              width: 150.0,
              child: GestureDetector(
                onTap: () => openImage(context, widget.image),
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.memory(
                    widget.image,
                    fit: BoxFit.cover,
                    // height: 200,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
