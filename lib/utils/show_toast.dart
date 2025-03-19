import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

void showToast(context, title) {
  CherryToast.success(
    title: Text(
      title.toString().trim(),
      style: TextStyle(
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.black
            : Colors.white,
      ),
    ),
    animationType: AnimationType.fromTop,
    toastDuration: Duration(milliseconds: 1400),
    backgroundColor: ThemeProvider.themeOf(context).id == "light_theme"
        ? Colors.white
        : const Color(0xff1a1a1a),
    shadowColor: ThemeProvider.themeOf(context).id == "light_theme"
        ? Colors.grey[200]!
        : Colors.grey[900]!,
  ).show(context);
}
