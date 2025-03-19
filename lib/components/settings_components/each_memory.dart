import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:theme_provider/theme_provider.dart';

class EachMemory extends StatefulWidget {
  const EachMemory({
    super.key,
    required this.memory,
    required this.forgetOneMemory,
  });

  final String memory;
  final Function forgetOneMemory;

  @override
  State<EachMemory> createState() => _EachMemoryState();
}

class _EachMemoryState extends State<EachMemory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 5.0,
        top: 5.0,
        bottom: 5.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ThemeProvider.themeOf(context).id == "light_theme"
                ? Colors.grey[300]!
                : Colors.grey[800]!,
            width: 0.3,
          ),
          bottom: BorderSide(
            color: ThemeProvider.themeOf(context).id == "light_theme"
                ? Colors.grey[300]!
                : Colors.grey[800]!,
            width: 0.3,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.memory,
              style: TextStyle(
                color: ThemeProvider.themeOf(context).id == "dark_theme"
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.forgetOneMemory(widget.memory);
            },
            icon: Icon(
              Ionicons.trash_outline,
              size: 15,
              color: ThemeProvider.themeOf(context).id == "dark_theme"
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
