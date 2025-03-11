import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class AttachFileButton extends StatefulWidget {
  const AttachFileButton({super.key});

  @override
  State<AttachFileButton> createState() => _AttachFileButtonState();
}

class _AttachFileButtonState extends State<AttachFileButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).iconTheme.color!.withAlpha(100),
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Ionicons.folder_open_outline,
            color: Theme.of(context).iconTheme.color,
            size: 18.0,
          ),
          // Text(
          //   'Attach File',
          //   style: TextStyle(
          //     color: Theme.of(context).iconTheme.color,
          //   ),
          // ),
        ],
      ),
    );
  }
}
