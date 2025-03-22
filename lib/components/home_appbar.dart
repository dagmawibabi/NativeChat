// dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:nativechat/utils/export_chat_history.dart';

import '../utils/import_chat_history.dart';

class HomeAppbar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppbar({
    super.key,
    required this.openDrawer,
    required this.creatSession,
    required this.toggleAPIKey,
    required this.clearConversation,
    this.session,
    required this.onChatHistoryImported,
  });

  final VoidCallback openDrawer;
  final VoidCallback creatSession;
  final VoidCallback toggleAPIKey;
  final VoidCallback clearConversation;
  final ChatSessionModel? session;
  final void Function(Iterable<Map<String, dynamic>> importedMessages)
      onChatHistoryImported;

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends State<HomeAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: Row(
        children: [
          IconButton(
            onPressed: widget.openDrawer,
            icon: Icon(
              Icons.history,
              size: 20.0,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      actions: [
        // Updated Import Chat History IconButton
        IconButton(
          onPressed: () async {
            final importedMessages = await importChatHistory(context);
            if (importedMessages != null) {
              if (widget.session == null) {
                // Create a new session if one doesn't exist.
                widget.onChatHistoryImported(importedMessages);
              } else {
                // Update the existing session.
                widget.session!.messages.clear();
                widget.session!.messages.addAll(importedMessages);
                widget.onChatHistoryImported(importedMessages);
              }
            }
          },
          icon: Icon(
            Icons.file_download_outlined,
            size: 20.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        // Export Chat History
        IconButton(
          onPressed: () async {
            if (widget.session != null && widget.session!.messages.isNotEmpty) {
              await exportChatHistory(widget.session!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No chat history to export.')),
              );
            }
          },
          icon: Icon(
            Icons.file_upload_outlined,
            size: 20.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        // API Key
        IconButton(
          onPressed: widget.toggleAPIKey,
          icon: Icon(
            Ionicons.key_outline,
            size: 18.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        // Clear Chat
        IconButton(
          onPressed: widget.clearConversation,
          icon: Icon(
            Ionicons.trash_outline,
            size: 18.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        // Start New Chat
        IconButton(
          onPressed: widget.creatSession,
          icon: Icon(
            Icons.add,
            size: 20.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
