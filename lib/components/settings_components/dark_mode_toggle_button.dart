import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class DarkModeToggleButton extends StatefulWidget {
  const DarkModeToggleButton({
    super.key,
  });

  @override
  State<DarkModeToggleButton> createState() => _DarkModeToggleButtonState();
}

class _DarkModeToggleButtonState extends State<DarkModeToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ThemeProvider.controllerOf(context).nextTheme();
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
                ThemeProvider.themeOf(context).id == "light_theme"
                    ? Icons.dark_mode_outlined
                    : Icons.wb_sunny_outlined,
                size: 22.0,
                color: ThemeProvider.themeOf(context).id == "dark_theme"
                    ? Colors.white
                    : Colors.black,
              ),
              Text(
                "Dark Mode",
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
