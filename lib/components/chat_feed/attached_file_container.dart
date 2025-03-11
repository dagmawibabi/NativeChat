// dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:theme_provider/theme_provider.dart';

class AttachedFileContainer extends StatefulWidget {
  const AttachedFileContainer({
    super.key,
    required this.fileName,
    required this.isUser,
    this.isAudio = false,
  });

  final String fileName;
  final bool isUser;
  final bool isAudio;

  @override
  State<AttachedFileContainer> createState() => _AttachedFileContainerState();
}

class _AttachedFileContainerState extends State<AttachedFileContainer> {
  @override
  Widget build(BuildContext context) {
    var color = ThemeProvider.themeOf(context).id == "light_theme"
        ? Colors.black
        : Colors.white;

    // Choose the leading icon based on isAudio flag.
    final icon = widget.isAudio
        ? Icons.multitrack_audio_outlined
        : Ionicons.folder_open_outline;

    return Container(
      alignment: Alignment.centerRight,
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      margin: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
        bottom: 5.0,
      ),
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 5.0,
        top: 6.0,
        bottom: 6.0,
      ),
      decoration: BoxDecoration(
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? const Color(0xfff2f2f2)
            : const Color(0xff1a1a1a),
        border: Border.all(
          color: ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.grey[300]!
              : Colors.grey[900]!,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            icon,
            color: color,
            size: 18.0,
          ),
          const SizedBox(width: 6.0),
          Expanded(
            child: Text(
              widget.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
