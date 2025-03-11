import "package:flutter/material.dart";
import "package:nativechat/state/is_one_sided_chat_mode_notifier.dart";
import "package:theme_provider/theme_provider.dart";

class UserInput extends StatefulWidget {
  const UserInput({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  var isOneSidedChatModeNotifier = IsOneSidedChatModeNotifier();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isOneSidedChatModeNotifier.isOneSidedChatMode,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment:
              value == true ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              width: value == true
                  ? MediaQuery.of(context).size.width * 0.9
                  : MediaQuery.of(context).size.width * 0.7,
              alignment:
                  value == true ? Alignment.centerLeft : Alignment.centerRight,
              margin: EdgeInsets.only(
                left: 5.0,
                right: value == true ? 0.0 : 5.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Container(
                decoration: value
                    ? null
                    : BoxDecoration(
                        color:
                            ThemeProvider.themeOf(context).id == "light_theme"
                                ? const Color(0xfff2f2f2)
                                : Colors.grey[900]!,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                padding: value
                    ? EdgeInsets.all(0.0)
                    : EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                child: Text(
                  widget.text,
                  textAlign: value == true ? TextAlign.left : TextAlign.right,
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
