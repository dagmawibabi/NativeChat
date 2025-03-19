// File: lib/components/input_box.dart
import 'package:flutter/material.dart';
import 'package:nativechat/components/input_box/input_mic_button.dart';
import 'package:nativechat/components/input_box/main_text_field.dart';
import 'package:nativechat/components/input_box/send_input_button.dart';
import 'package:nativechat/components/input_box/voice_mode_button.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:nativechat/components/attach_file_popup_menu/attach_file_popup_menu.dart';
import 'package:theme_provider/theme_provider.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    super.key,
    required this.summarizeText,
    required this.chatWithAI,
    required this.onPickFile,
    required this.onPickImage,
    required this.onPickAudio,
    required this.onPickCamera,
    required this.isSummarizeInContext,
    required this.userMessageController,
    required this.toggleVoiceMode,
    required this.isInVoiceMode,
    required this.speechToText,
    required this.startListening,
    required this.stopListening,
  });

  final Function summarizeText;
  final Function chatWithAI;
  final VoidCallback onPickFile;
  final VoidCallback onPickImage;
  final VoidCallback onPickAudio;
  final VoidCallback onPickCamera;
  final bool isSummarizeInContext;
  final TextEditingController userMessageController;
  final Function toggleVoiceMode;
  final SpeechToText speechToText;
  final Function startListening;
  final Function stopListening;
  final bool isInVoiceMode;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 8.0,
        top: 2.0,
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? const Color(0xfff2f2f2)
            : const Color(0xff1a1a1a),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainTextField(
            userMessageController: widget.userMessageController,
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Attach File Menu and Voice Mode
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Row(
                  spacing: 10.0,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Attach Files
                    AttachFilePopupMenu(
                      onPickFile: widget.onPickFile,
                      onPickImage: widget.onPickImage,
                      onPickAudio: widget.onPickAudio,
                      onPickCamera: widget.onPickCamera,
                    ),
                    // Voice Mode
                    VoiceModeButton(
                      toggleVoiceMode: widget.toggleVoiceMode,
                      isInVoiceMode: widget.isInVoiceMode,
                    ),
                  ],
                ),
              ),
              // Send and Mic Button
              widget.isInVoiceMode
                  ? InputMicButton(
                      speechToText: widget.speechToText,
                      startListening: widget.startListening,
                      stopListening: widget.stopListening,
                    )
                  : SendInputButton(
                      isSummarizeInContext: widget.isSummarizeInContext,
                      summarizeText: widget.summarizeText,
                      chatWithAI: widget.chatWithAI,
                    )
            ],
          ),
        ],
      ),
    );
  }
}
