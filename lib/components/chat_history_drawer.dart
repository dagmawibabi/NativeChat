// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:intl/intl.dart';
import 'package:nativechat/pages/settings_page.dart';
import 'package:nativechat/utils/show_toast.dart';
import 'package:theme_provider/theme_provider.dart';

class ChatHistoryDrawer extends StatefulWidget {
  final void Function(ChatSessionModel) onChatSelected;
  const ChatHistoryDrawer({
    super.key,
    required this.onChatSelected,
  });

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  Box<ChatSessionModel>? chatBox;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openBox() async {
    final box = await Hive.openBox<ChatSessionModel>('chat_session');
    setState(() {
      chatBox = box;
    });
  }

  ChatSessionModel createSession() {
    final newSession = ChatSessionModel(
        title: "New Chat", messages: [], createdAt: DateTime.now());
    chatBox?.add(newSession);
    return newSession;
  }

  Future<void> deleteSpecificChatHistory(chatBox, sessions, index) async {
    var sessionToDelete = chatBox!.values
        .firstWhere((session) => session.id == sessions[index].id);
    await chatBox!.delete(
      sessionToDelete.key,
    );
  }

  Future<void> renameChatHistory(BuildContext context, Box<ChatSessionModel> chatBox, List<ChatSessionModel> sessions, int index) async {
    final TextEditingController renameController = TextEditingController(text: sessions[index].title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Chat'),
        content: TextField(
          controller: renameController,
          decoration: InputDecoration(
            hintText: 'Enter new name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, renameController.text),
            child: Text('Rename'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      var sessionToRename = chatBox.values
          .firstWhere((session) => session.id == sessions[index].id);
      sessionToRename.title = result.trim();
      await sessionToRename.save();
      showToast(context, "Chat renamed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ThemeProvider.themeOf(context).id == "light_theme"
          ? Colors.white
          : const Color(0xff1a1a1a),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
              top: 60.0,
              left: 15.0,
              right: 15.0,
              bottom: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 18,
                    color: ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onChatSelected(createSession());
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.add,
                        size: 20.0,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chats',
                prefixIcon: Icon(Icons.search,
                    color: ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.grey[600]
                        : Colors.grey[400]),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: ThemeProvider.themeOf(context).id == "light_theme"
                    ? Colors.grey[200]
                    : Colors.grey[800],
              ),
              style: TextStyle(
                color: ThemeProvider.themeOf(context).id == "light_theme"
                    ? Colors.black
                    : Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // History List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: chatBox?.listenable() ??
                  ValueNotifier<Future<Box<ChatSessionModel>>>(
                    Hive.openBox('chat_session'),
                  ),
              builder: (context, box, _) {
                if (chatBox == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var sessions = chatBox!.values.toList().reversed.toList();

                // Filter sessions based on search query
                if (_searchQuery.isNotEmpty) {
                  sessions = sessions.where((session) {
                    // Search in title
                    if (session.title.toLowerCase().contains(_searchQuery)) {
                      return true;
                    }

                    // Search in messages
                    if (session.messages.isNotEmpty) {
                      for (var message in session.messages) {
                        if (message['content']?.toString().toLowerCase().contains(_searchQuery) ?? false) {
                          return true;
                        }
                      }
                    }

                    return false;
                  }).toList();
                }

                return sessions.isEmpty
                    ? Center(
                  child: Text(
                    _searchQuery.isEmpty ? "No chat history" : "No results found",
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id ==
                          "light_theme"
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: index == 0
                              ? BorderSide(
                            color:
                            ThemeProvider.themeOf(context).id ==
                                "light_theme"
                                ? Colors.grey[300]!
                                : Colors.grey[800]!,
                            width: 0.3,
                          )
                              : BorderSide(color: Colors.transparent),
                          bottom: BorderSide(
                            color: ThemeProvider.themeOf(context).id ==
                                "light_theme"
                                ? Colors.grey[300]!
                                : Colors.grey[800]!,
                            width: 0.3,
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                          left: 12,
                        ),
                        title: Text(
                          sessions[index].title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id ==
                                "light_theme"
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('hh:mm a, MMM d, yyyy')
                              .format(sessions[index].createdAt!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                renameChatHistory(context, chatBox!, sessions, index);
                              },
                              icon: Icon(
                                Ionicons.pencil_outline,
                                size: 15,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await deleteSpecificChatHistory(
                                  chatBox,
                                  sessions,
                                  index,
                                );
                                showToast(context, "Deleted Chat History");
                              },
                              icon: Icon(
                                Ionicons.trash_outline,
                                size: 15,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          widget.onChatSelected(sessions[index]);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Delete All Chats and Settings
          Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              bottom: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delete All Chats
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_sweep_outlined,
                      size: 25.0,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      chatBox?.clear();
                      setState(() {});
                      showToast(context, "Deleted All Chat History");
                    },
                  ),
                ),

                // Settings
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SettingsPage();
                      }),
                    );
                  },
                  icon: Icon(
                    Ionicons.settings_outline,
                    size: 20.0,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
