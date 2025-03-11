// dart
import 'package:flutter/material.dart';
import 'package:nativechat/components/chat_feed/ai_response.dart';
import 'package:nativechat/components/chat_feed/attached_file_container.dart';
import 'package:nativechat/components/chat_feed/chat_image_container.dart';
import 'package:nativechat/components/chat_feed/circle_dot.dart';
import 'package:nativechat/components/chat_feed/circle_loading_animation.dart';
import 'package:nativechat/components/system_response.dart';
import 'package:nativechat/components/chat_feed/user_input.dart';
import 'package:nativechat/state/is_one_sided_chat_mode_notifier.dart';

class ConversationFeed extends StatefulWidget {
  final ScrollController scrollController;
  final List<dynamic> chatHistory;

  const ConversationFeed({
    super.key,
    required this.scrollController,
    required this.chatHistory,
  });

  @override
  State<ConversationFeed> createState() => _ConversationFeedState();
}

class _ConversationFeedState extends State<ConversationFeed> {
  var isOneSidedChatModeNotifier = IsOneSidedChatModeNotifier();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isOneSidedChatModeNotifier.isOneSidedChatMode,
      builder: (context, value, child) {
        return Expanded(
          flex: 2,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 200.0),
            controller: widget.scrollController,
            itemCount: widget.chatHistory.length,
            itemBuilder: (context, index) {
              final chat = widget.chatHistory[index];
              final bool isUser = chat['from'] == "user";
              final bool isSystem = chat['from'] == "system";
              final bool isLast = index == widget.chatHistory.length - 1;

              // Handle file attachments
              if (chat.containsKey('file') && chat['file'] != null) {
                final fileData = chat['file'];
                // If the attached file is an image
                if (fileData['isImage'] == true) {
                  return Column(
                    crossAxisAlignment: value
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      ChatImageContainer(
                        image: fileData['bytes'],
                      ),
                      if ((chat['content'] as String).trim().isNotEmpty)
                        UserInput(
                          text: chat['content'],
                        ),
                    ],
                  );
                } else {
                  // For non-image file attachments, show file name and the user prompt.
                  String fileName = '';
                  if (fileData.containsKey('name') &&
                      fileData['name'] != null) {
                    fileName = fileData['name'];
                  } else if (fileData.containsKey('attachedFileName') &&
                      fileData['attachedFileName'] != null) {
                    fileName = fileData['attachedFileName'];
                  } else {
                    fileName = 'Preview File';
                  }
                  return Column(
                    crossAxisAlignment: value
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      AttachedFileContainer(
                        isAudio: fileData['isAudio'],
                        fileName: fileName,
                        isUser: isUser,
                      ),
                      if ((chat['content'] as String).trim().isNotEmpty)
                        UserInput(
                          text: chat['content'],
                        ),
                    ],
                  );
                }
              }
              // Handle images (legacy or with prompt)
              else if (chat.containsKey('image') && chat['image'] != null) {
                return Column(
                  crossAxisAlignment:
                      value ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    ChatImageContainer(
                      image: chat['image'],
                    ),
                    if ((chat['content'] as String).trim().isNotEmpty)
                      UserInput(
                        text: chat['content'],
                      ),
                  ],
                );
              }

              // Handle regular messages.
              Widget messageWidget;
              if (isSystem) {
                messageWidget = value == false
                    ? SystemResponse(
                        chatObject: chat,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SystemResponse(
                            chatObject: chat,
                          ),
                          chat["isError"] == true
                              ? isLast
                                  ? CircleDot(leftPadding: 16.0)
                                  : Container()
                              : CircleLoadingAnimation()
                        ],
                      );
              } else if (isUser) {
                messageWidget = UserInput(
                  text: chat['content'],
                );
              } else {
                messageWidget = AIResponse(
                  text: chat['content'].toString(),
                  isLast: isLast,
                );
              }

              return messageWidget;
            },
          ),
        );
      },
    );
  }
}
