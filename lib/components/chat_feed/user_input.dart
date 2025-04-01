// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:nativechat/components/chat_feed/codeblock.dart";
import "package:nativechat/state/is_one_sided_chat_mode_notifier.dart";
import "package:nativechat/utils/show_toast.dart";
import "package:theme_provider/theme_provider.dart";
import "package:url_launcher/url_launcher.dart";

import "../../utils/copy_to_clipboard.dart";

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
            GestureDetector(
              onDoubleTap: () async {
                await copyToClipboard(widget.text);
                showToast(context, "Copied");
              },
              child: Container(
                width: value == true
                    ? MediaQuery.of(context).size.width * 0.9
                    : MediaQuery.of(context).size.width * 0.7,
                alignment: value == true
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
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
                  child: SelectableRegion(
                  focusNode : FocusNode(),
                   selectionControls:MaterialTextSelectionControls(),
                   child: GptMarkdown(
                    widget.text,
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.black
                          : Colors.grey[400],
                    ),
                    codeBuilder: (context, name, code, closed) => Codeblock(
                      code: code,
                      name: name,
                    ),
                    onLinkTab: (url, title) async {
                      var parsedURL = Uri.parse(url);
                      await launchUrl(
                        parsedURL,
                        mode: LaunchMode.inAppBrowserView,
                      );
                    },
                  ),
        ),
                  // Text(
                  //   widget.text,
                  //   textAlign: value == true ? TextAlign.left : TextAlign.right,
                  //   style: TextStyle(
                  //       color: ThemeProvider.themeOf(context).id == "light_theme"
                  //           ? Colors.black
                  //           : Colors.white),
                  // ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
