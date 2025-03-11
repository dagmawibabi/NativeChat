import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:nativechat/models/settings.dart';
import 'package:theme_provider/theme_provider.dart';
// import 'package:flutter/services.dart';

import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(ChatSessionModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ChatSessionModel? session;
  @override
  Widget build(BuildContext context) {
    var darkGreyColor = Color(0xff0a0a0a);
    // var darkGreyColor = Color(0xff0f0f0f);
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );

    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.immersive,
    //   overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    // );

    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      defaultThemeId: "dark_theme",
      themes: [
        AppTheme(
          id: "light_theme",
          description: "light_theme",
          data: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            ),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
          ),
        ),
        AppTheme(
          id: "dark_theme",
          description: "dark_theme",
          data: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: darkGreyColor,
            appBarTheme: AppBarTheme(
              backgroundColor: darkGreyColor,
              iconTheme: IconThemeData(
                color: Colors.grey[500],
              ),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            routes: {
              "/": (context) => Homepage(session: session),
            },
          ),
        ),
      ),
    );
  }
}
