import 'package:flutter/material.dart';
import 'package:nativechat/constants/urls.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

class APIKeyInput extends StatefulWidget {
  const APIKeyInput({
    super.key,
    required this.getSettings,
  });

  final Function getSettings;

  @override
  State<APIKeyInput> createState() => _APIKeyInputState();
}

class _APIKeyInputState extends State<APIKeyInput> {
  String apiKey = "";
  TextEditingController apiKeyController = TextEditingController();

  void getAPIKey() async {
    await launchUrl(Uri.parse(googleAIStudioURL));
  }

  void getSavedAPIKey() async {
    Box settingBox = await Hive.openBox("settings");
    apiKey = await settingBox.get("apikey") ?? "";
    await settingBox.close();
    setState(() {});
  }

  void saveAPIKey() async {
    Box settingBox = await Hive.openBox("settings");
    await settingBox.put("apikey", apiKeyController.text.trim());
    apiKey = await settingBox.get("apikey") ?? "";
    await settingBox.close();
    setState(() {
      apiKeyController.clear();
    });
    widget.getSettings();
  }

  void clearAPIKey() async {
    apiKey = "";
    Box settingBox = await Hive.openBox("settings");
    await settingBox.put("apikey", "");
    apiKey = await settingBox.get("apikey") ?? "";
    await settingBox.close();
    setState(() {
      apiKeyController.clear();
    });
    widget.getSettings();
  }

  @override
  void initState() {
    super.initState();
    getSavedAPIKey();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 8.0,
        top: 2.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            20.0,
          ),
          topRight: Radius.circular(
            20.0,
          ),
        ),
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? const Color(0xfff2f2f2)
            : const Color(0xff1a1a1a),
      ),
      child: Column(
        spacing: 18.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // InputBox
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: apiKeyController,
                  cursorColor:
                      ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.black
                          : Colors.white,
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.black
                          : Colors.white),
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: apiKey == "" ? "add api key..." : apiKey,
                    hintStyle: TextStyle(color: Colors.grey[700]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),

          // API Key Buttons
          Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            alignment: WrapAlignment.center,
            children: [
              // Get API Key
              GestureDetector(
                onTap: () {
                  getAPIKey();
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[800]!,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Text(
                      'Get API Key',
                      style: TextStyle(
                        color:
                            ThemeProvider.themeOf(context).id == "light_theme"
                                ? Colors.black
                                : Colors.white,
                      ),
                    )),
              ),

              // Save API Key
              GestureDetector(
                onTap: () {
                  saveAPIKey();
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[800]!,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Text(
                      'Save API Key',
                      style: TextStyle(
                        color:
                            ThemeProvider.themeOf(context).id == "light_theme"
                                ? Colors.black
                                : Colors.white,
                      ),
                    )),
              ),

              // Clear API Key
              GestureDetector(
                onTap: () {
                  clearAPIKey();
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[800]!,
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Text(
                      'Clear API Key',
                      style: TextStyle(
                        color:
                            ThemeProvider.themeOf(context).id == "light_theme"
                                ? Colors.black
                                : Colors.white,
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
