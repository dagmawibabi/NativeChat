import 'package:flutter/material.dart';
import 'package:nativechat/state/is_one_sided_chat_mode_notifier.dart';
import 'package:theme_provider/theme_provider.dart';

class OneSidedChatToggleButton extends StatefulWidget {
  const OneSidedChatToggleButton({
    super.key,
  });

  @override
  State<OneSidedChatToggleButton> createState() =>
      _OneSidedChatToggleButtonState();
}

class _OneSidedChatToggleButtonState extends State<OneSidedChatToggleButton> {
  var isOneSidedChatModeNotifier = IsOneSidedChatModeNotifier();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          isOneSidedChatModeNotifier.toggle();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 14.0,
          ),
          decoration: BoxDecoration(
            color: ThemeProvider.themeOf(context).id == "light_theme"
                ? Colors.grey[200]!
                : Colors.grey[900]!,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.grey[400]!
                  : Colors.grey[800]!,
            ),
          ),
          child: Column(
            spacing: 10.0,
            children: [
              ValueListenableBuilder(
                valueListenable: isOneSidedChatModeNotifier.isOneSidedChatMode,
                builder: (context, value, child) {
                  return Icon(
                    value
                        ? Icons.align_horizontal_right_outlined
                        : Icons.align_horizontal_left_outlined,
                    size: 22.0,
                    color: ThemeProvider.themeOf(context).id == "dark_theme"
                        ? Colors.white
                        : Colors.black,
                  );
                },
              ),
              Text(
                "One Sided Chat",
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).id == "dark_theme"
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
