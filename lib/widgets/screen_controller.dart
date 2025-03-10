import 'package:flutter/material.dart';

class ScreenController extends StatefulWidget {
  const ScreenController({super.key});

  @override
  State<ScreenController> createState() => ScreenControllerState();
}

class ScreenControllerState extends State<ScreenController> {
  Map<String, String> screenInfo = {"width": "300", "height": "500"};

  /// Updates the screen info and rebuilds only this widget.
  void changeScreenSizeNotif(String width, String height) {
    setState(() {
      screenInfo["width"] = width;
      screenInfo["height"] = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              changeScreenSizeNotif("300", "500");
            },
            child: const Text("Mobile"),
          ),
          TextButton(
            onPressed: () {
              changeScreenSizeNotif("800", "400");
            },
            child: const Text("Desktop"),
          ),
          Text("${screenInfo["width"]} x ${screenInfo["height"]}"),
        ],
      ),
    );
  }
}
