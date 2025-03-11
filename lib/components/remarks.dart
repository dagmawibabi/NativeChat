import 'package:flutter/material.dart';
import 'package:nativechat/constants/remarks.dart';
import 'package:nativechat/constants/urls.dart';
import 'package:url_launcher/url_launcher.dart';

class Remarks extends StatefulWidget {
  const Remarks({super.key});

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 30.0,
        ),
        child: ListView(
          reverse: true,
          children: [
            Column(
              spacing: 30.0,
              children: [
                Image.asset(
                  'assets/logo/logoBorder.png',
                  height: 80.0,
                ),
                Text(
                  remarks,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600]!,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Open the project source code in a browser
                    await launchUrl(Uri.parse(github));
                  },
                  child: Text(
                    "This project is free and open source. Click here to star, contribute or view the project source code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
