import "package:flutter/material.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:nativechat/components/chat_feed/circle_dot.dart";
import "package:nativechat/components/chat_feed/codeblock.dart";
import "package:nativechat/components/chat_feed/dashed_border_exracted.dart";
import "package:nativechat/state/is_one_sided_chat_mode_notifier.dart";
import "package:theme_provider/theme_provider.dart";
import "package:url_launcher/url_launcher.dart";

class AIResponse extends StatefulWidget {
  const AIResponse({
    super.key,
    required this.text,
    this.isLast = false,
  });

  final String text;
  final bool isLast;

  @override
  State<AIResponse> createState() => _AIResponseState();
}

class _AIResponseState extends State<AIResponse> {
  var isOneSidedChatModeNotifier = IsOneSidedChatModeNotifier();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isOneSidedChatModeNotifier.isOneSidedChatMode,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(
                left: value == true ? 25.0 : 0.0,
              ),
              padding: EdgeInsets.only(
                top: 14.0,
                bottom: value == true ? 25.0 : 14.0,
              ),
              decoration: value == true
                  ? BoxDecoration(
                      border: dashedBorderExtracted,
                    )
                  : BoxDecoration(),
              child: Container(
                margin: EdgeInsets.only(
                  left: 6.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: GptMarkdown(
                  widget.text,
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.black
                          : Colors.grey[400]),
                  codeBuilder: (context, name, code, closed) =>
                      Codeblock(code: code, name: name),
                  onLinkTab: (url, title) async {
                    var parsedURL = Uri.parse(url);
                    await launchUrl(
                      parsedURL,
                      mode: LaunchMode.inAppBrowserView,
                    );
                  },
                ),
              ),
            ),
            widget.isLast == true ? CircleDot(leftPadding: 16.0) : Container(),
          ],
        );
      },
    );
  }
}
