import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeAppbar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppbar({
    super.key,
    required this.openDrawer,
    required this.creatSession,
    required this.toggleAPIKey,
    required this.clearConversation,
  });

  final VoidCallback openDrawer;
  final VoidCallback creatSession;
  final VoidCallback toggleAPIKey;
  final VoidCallback clearConversation;

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
