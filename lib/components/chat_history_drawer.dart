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

  @override
  void initState() {
    super.initState();
    _openBox();
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

  // rename title
  Future<void> renameSpecificChatHistory(
      chatBox, sessions, index, newTitle) async {
    var sessionForRename = chatBox!.values
        .firstWhere((session) => session.id == sessions[index].id);

    sessionForRename.title = newTitle;
    await sessionForRename.save();
    selectedIndex = -1;
  }

  int selectedIndex = -1;

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
                return sessions.isEmpty
                    ? Center(
                        child: Text(
                          "No chat history",
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
                                ), // Dim border bottom
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 12,
                              ),
                              title: selectedIndex == index
                                  ? TextFormField(
                                      style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id !=
                                                    "light_theme"
                                                ? Colors.grey[300]!
                                                : Colors.grey[800]!,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 6,
                                        ),
                                      ),
                                      initialValue: sessions[index].title,
                                      onFieldSubmitted: (value) => {
                                        if (value.isNotEmpty)
                                          {
                                            renameSpecificChatHistory(
                                              chatBox,
                                              sessions,
                                              index,
                                              value,
                                            )
                                          }
                                      },
                                    )
                                  : Text(
                                      sessions[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
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
                                  GestureDetector(
                                    onTap: () async {
                                      selectedIndex = index;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Ionicons.pencil,
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
                                      showToast(
                                          context, "Deleted Chat History");
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
              right: 15.0,
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
