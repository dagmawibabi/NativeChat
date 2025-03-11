// Dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/googlecode.dart';
import 'package:flutter_highlight/themes/hybrid.dart';
import 'package:flutter_highlight/themes/idea.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';
import 'package:flutter_highlight/themes/tomorrow.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:theme_provider/theme_provider.dart';

class Codeblock extends StatefulWidget {
  const Codeblock({super.key, required this.code, required this.name});

  final String code;
  final String name;

  @override
  State<Codeblock> createState() => _CodeblockState();
}

class _CodeblockState extends State<Codeblock> {
  var _copied = false;
  var _collapse = false;
  int currentLightThemeIndex = 0;
  int currentDarkThemeIndex = 0;

  // List of themes for light mode.
  final List<Map<String, dynamic>> _lightThemes = [
    {'name': 'atomOneLight', 'theme': atomOneLightTheme},
    {'name': 'github', 'theme': githubTheme},
    {'name': 'googlecode', 'theme': googlecodeTheme},
    {'name': 'solarizedLight', 'theme': solarizedLightTheme},
    {'name': 'atomOneLight', 'theme': atomOneLightTheme},
    {'name': 'github', 'theme': githubTheme},
    {'name': 'googlecode', 'theme': googlecodeTheme},
    {'name': 'solarizedLight', 'theme': solarizedLightTheme},
    {'name': 'tomorrow', 'theme': tomorrowTheme},
    {'name': 'vs', 'theme': vsTheme},
    {'name': 'idea', 'theme': ideaTheme},
  ];

  // List of themes for dark mode.
  final List<Map<String, dynamic>> _darkThemes = [
    {'name': 'monokai', 'theme': monokaiTheme},
    {'name': 'monokaiSublime', 'theme': monokaiSublimeTheme},
    {'name': 'atomOneDark', 'theme': atomOneDarkTheme},
    {'name': 'dracula', 'theme': draculaTheme},
    {'name': 'a11yDark', 'theme': a11yDarkTheme},
    {'name': 'hybrid', 'theme': hybridTheme},
    {'name': 'solarizedDark', 'theme': solarizedDarkTheme},
    {'name': 'vs2015', 'theme': vs2015Theme},
  ];

  void copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {
      _copied = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _copied = false;
    });
  }

  // dynamic activeThemes;
  void changeTheme() {
    // Determine the active theme list based on the current theme.
    final bool isLight =
        ThemeProvider.themeOf(context).id == "light_theme" ? true : false;
    if (isLight == true) {
      currentLightThemeIndex += 1;
      if (currentLightThemeIndex >= _lightThemes.length) {
        currentLightThemeIndex = 0;
      }
      setState(() {});
    } else {
      currentDarkThemeIndex += 1;
      if (currentDarkThemeIndex >= _darkThemes.length) {
        currentDarkThemeIndex = 0;
      }
      setState(() {});
    }
    saveCurrentThemeIndex();
  }

  void getSavedThemeIndex() async {
    Box settingBox = await Hive.openBox("settings");
    currentLightThemeIndex =
        await settingBox.get("currentLightThemeIndex") ?? 0;
    currentDarkThemeIndex = await settingBox.get("currentDarkThemeIndex") ?? 0;
    setState(() {});
    settingBox.close();
  }

  void saveCurrentThemeIndex() async {
    Box settingBox = await Hive.openBox("settings");
    await settingBox.put("currentLightThemeIndex", currentLightThemeIndex);
    await settingBox.put("currentDarkThemeIndex", currentDarkThemeIndex);
    settingBox.close();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSavedThemeIndex();
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = ThemeProvider.themeOf(context).id == "light_theme";

    return Material(
      color: isLight ? const Color(0xfff2f2f2) : const Color(0xff121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row with Name, Theme, Copy and Collapse Buttons
          Container(
            decoration: BoxDecoration(
              color: isLight ? Colors.grey[300] : const Color(0xff151515),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: const EdgeInsets.only(
              left: 14.0,
              right: 10.0,
              top: 6.0,
              bottom: 6.0,
            ),
            child: Row(
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    color: isLight ? Colors.black : Colors.grey[700],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => {changeTheme()},
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Ionicons.color_palette_outline,
                      size: 18,
                      color: isLight ? Colors.grey[700] : Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: copyToClipboard,
                  child: Icon(
                    _copied ? Icons.done : Icons.content_paste,
                    size: 15,
                    color: _copied
                        ? (isLight ? Colors.green[600] : Colors.greenAccent)
                        : (isLight ? Colors.grey[700] : Colors.grey[500]),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _collapse = !_collapse;
                    });
                  },
                  child: Icon(
                    _collapse
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined,
                    size: 18,
                    color: _collapse
                        ? (isLight ? Colors.green[600] : Colors.greenAccent)
                        : (isLight ? Colors.grey[700] : Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),

          // Code with Syntax Highlighting
          Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(
              maxHeight: _collapse ? 150.0 : double.infinity,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HighlightView(
                widget.code,
                language: widget.name.isNotEmpty
                    ? widget.name.toLowerCase()
                    : 'plaintext',
                theme: isLight == true
                    ? _lightThemes[currentLightThemeIndex]['theme']
                    : _darkThemes[currentDarkThemeIndex]['theme'],
                padding: const EdgeInsets.all(12.0),
                textStyle: TextStyle(
                  fontFamily: 'SourceCodePro',
                  fontSize: 14.0,
                ),
              ),
            ),
          ),

          // Current Theme Name
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 1.0,
            ),
            child: Row(
              spacing: 4.0,
              children: [
                Icon(
                  Ionicons.color_palette_outline,
                  size: 14,
                  color: isLight ? Colors.grey[700] : Colors.grey[500],
                ),
                Text(
                  isLight == true
                      ? _lightThemes[currentLightThemeIndex]['name']
                      : _darkThemes[currentDarkThemeIndex]['name'],
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
