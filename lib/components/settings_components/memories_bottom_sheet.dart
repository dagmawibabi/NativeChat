import 'package:flutter/material.dart';
import 'package:nativechat/ai/function_calls/ai_memory/forget_memories.dart';
import 'package:nativechat/ai/function_calls/ai_memory/forget_one_memory.dart';
import 'package:nativechat/ai/function_calls/ai_memory/get_memories.dart';
import 'package:nativechat/ai/function_calls/ai_memory/save_memory.dart';
import 'package:nativechat/components/settings_components/each_memory.dart';
import 'package:nativechat/components/settings_components/memories_bottom_sheet_header.dart';
import 'package:theme_provider/theme_provider.dart';

class MemoriesBottomSheet extends StatefulWidget {
  const MemoriesBottomSheet({super.key});

  @override
  State<MemoriesBottomSheet> createState() => _MemoriesBottomSheetState();
}

class _MemoriesBottomSheetState extends State<MemoriesBottomSheet> {
  var oldMemories = [];

  void getMemoriesInit() async {
    oldMemories = await getMemories();
    setState(() {});
  }

  void forgetAllMemories() async {
    await forgetMemory();
    oldMemories = [];
    setState(() {});
  }

  void _forgetOneMemory(memory) async {
    await forgetOneMemory(memory);
    getMemoriesInit();
  }

  void addMemory(memory) async {
    oldMemories.add(memory);
    await saveMemory(memory);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMemoriesInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.grey[200]!
            : Colors.grey[900]!,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: oldMemories.isEmpty
          ? ListView(
              children: [
                MemoriesBottomSheetHeader(
                  disableDeleteAll: true,
                  forgetAllMemories: forgetAllMemories,
                  addMemory: addMemory,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Text(
                    "No memories found.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == "dark_theme"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: oldMemories.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    index == 0
                        ? MemoriesBottomSheetHeader(
                            disableDeleteAll: false,
                            forgetAllMemories: forgetAllMemories,
                            addMemory: addMemory,
                          )
                        : Container(),
                    EachMemory(
                      memory: oldMemories[index],
                      forgetOneMemory: _forgetOneMemory,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
