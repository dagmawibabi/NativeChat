import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class MemoriesBottomSheetHeader extends StatefulWidget {
  const MemoriesBottomSheetHeader({
    super.key,
    required this.disableDeleteAll,
    required this.forgetAllMemories,
    required this.addMemory,
  });

  final bool disableDeleteAll;
  final Function forgetAllMemories;
  final Function addMemory;

  @override
  State<MemoriesBottomSheetHeader> createState() =>
      _MemoriesBottomSheetHeaderState();
}

class _MemoriesBottomSheetHeaderState extends State<MemoriesBottomSheetHeader> {
  TextEditingController memoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Memory Header
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 15.0,
            bottom: 10.0,
          ),
          child: Text(
            "Add Memory",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: ThemeProvider.themeOf(context).id == "dark_theme"
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        SizedBox(height: 5.0),

        // Add Memory
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 5.0,
            bottom: 10.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: memoryController,
                    cursorColor:
                        ThemeProvider.themeOf(context).id == "light_theme"
                            ? Colors.black
                            : Colors.white,
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.black
                          : Colors.white,
                    ),
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "something about you...",
                      hintStyle: TextStyle(
                        color:
                            ThemeProvider.themeOf(context).id == "light_theme"
                                ? Colors.black
                                : Colors.grey[500],
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor:
                          ThemeProvider.themeOf(context).id == "light_theme"
                              ? const Color(0xffe0e0e0)
                              : const Color(0xff1a1a1a),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (memoryController.text.toString().trim() != "") {
                    widget.addMemory(memoryController.text);
                    memoryController.clear();
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: ThemeProvider.themeOf(context).id == "dark_theme"
                      ? Colors.white
                      : Colors.black,
                ),
              )
            ],
          ),
        ),

        // Memories Header
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 5.0,
            // bottom: 10.0,
            top: 5.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Memories",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: ThemeProvider.themeOf(context).id == "dark_theme"
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              widget.disableDeleteAll
                  ? SizedBox(
                      height: 50.0,
                      width: 10.0,
                    )
                  : IconButton(
                      onPressed: () async {
                        widget.forgetAllMemories();
                      },
                      icon: Icon(
                        Icons.delete_sweep_outlined,
                        size: 20.0,
                        color: ThemeProvider.themeOf(context).id == "dark_theme"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
