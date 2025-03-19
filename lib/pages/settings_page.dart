import 'package:flutter/material.dart';
import 'package:nativechat/components/settings_components/dark_mode_toggle_button.dart';
import 'package:nativechat/components/settings_components/memories_buttons.dart';
import 'package:nativechat/components/settings_components/one_sided_chat_toggle_button.dart';
import 'package:nativechat/state/is_one_sided_chat_mode_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var isOneSidedChatModeNotifier = IsOneSidedChatModeNotifier();

  @override
  void initState() {
    super.initState();
    isOneSidedChatModeNotifier.getIsOneSidedMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        children: [
          Row(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [DarkModeToggleButton(), OneSidedChatToggleButton()],
          ),
          SizedBox(height: 10.0),
          Row(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MemoriesButtons(),
            ],
          ),
        ],
      ),
    );
  }
}
