import 'package:flutter/material.dart';
import 'package:nativechat/components/settings_components/memories_bottom_sheet.dart';
import 'package:theme_provider/theme_provider.dart';

class MemoriesButtons extends StatefulWidget {
  const MemoriesButtons({super.key});

  @override
  State<MemoriesButtons> createState() => _MemoriesButtonsState();
}

class _MemoriesButtonsState extends State<MemoriesButtons> {
  void showMemories() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MemoriesBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showMemories();
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
              Icon(
                Icons.memory_outlined,
                size: 22.0,
                color: ThemeProvider.themeOf(context).id == "dark_theme"
                    ? Colors.white
                    : Colors.black,
              ),
              Text(
                "Memories",
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
