import 'package:flutter/material.dart';
import 'package:nativechat/components/chat_feed/circle_dot.dart';
import 'package:nativechat/ai/prompt_suggestions.dart';
import 'package:theme_provider/theme_provider.dart';

import '../state/is_one_sided_chat_mode_notifier.dart';

class PromptSuggestionsFeed extends StatefulWidget {
  const PromptSuggestionsFeed({
    super.key,
    required this.chatWithAI,
    required this.userMessageController,
  });

  final Function chatWithAI;
  final TextEditingController userMessageController;

  @override
  State<PromptSuggestionsFeed> createState() => _PromptSuggestionsFeedState();
}

class _PromptSuggestionsFeedState extends State<PromptSuggestionsFeed> {
  late List<String> randomPromptSuggestions;
  var isOneSidedChatModeNotifier = IsOneSidedChatModeNotifier();

  @override
  void initState() {
    super.initState();
    promptSuggestions.shuffle();
    randomPromptSuggestions = promptSuggestions.sublist(0, 8).cast<String>();
    // Sort by character lenght
    randomPromptSuggestions.sort((a, b) => a.length.compareTo(b.length));
  }

  void enterPromptSuggestion(promptObject) {
    setState(() {
      widget.userMessageController.text = promptObject;
    });
    widget.chatWithAI();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100.0,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(
          left: 13.0,
          top: 30.0,
        ),
        child: ListView.builder(
          itemCount: randomPromptSuggestions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                enterPromptSuggestion(randomPromptSuggestions[index]);
              },
              child: Builder(builder: (context) {
                return ValueListenableBuilder(
                  valueListenable:
                      isOneSidedChatModeNotifier.isOneSidedChatMode,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: value
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          randomPromptSuggestions[index],
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id ==
                                    "light_theme"
                                ? Colors.grey[900]!
                                : Colors.grey[400]!,
                          ),
                        ),
                        SizedBox(height: 25.0),
                        index == randomPromptSuggestions.length - 1
                            ? Row(
                                mainAxisAlignment: value
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  CircleDot(
                                    leftPadding: 4.0,
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    );
                  },
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
