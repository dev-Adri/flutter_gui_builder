// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'screen.dart';
import '../models/virtual_widget.dart' as vw;

/// A widget that represents the screen stack.
class ScreenStack extends StatefulWidget {
  /// A callback function that takes the width and height of the screen as strings.
  final Function(String, String) changeScreenSizeNotif;

  const ScreenStack({super.key, required this.changeScreenSizeNotif});

  @override
  State<ScreenStack> createState() => _ScreenStackState();
}

// TODO: Figure out a way to generate widgets inside widgets
// TODO: Create a 'history' file so that there are undos and redoes allowed
// TODO: Make each widget clickable and draggable
// TODO: Clicked widgets should show their properties, and they can be changed
// TODO: Changing properties refreshes the screen_stack

class _ScreenStackState extends State<ScreenStack> {
  Widget tree = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: Text("Empty screen")),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screen(
          initialHeight: 500,
          initialWidth: 300,
          changedScreenSizeNotif: widget.changeScreenSizeNotif,
        ),
        // TOD O: onAccept : add widget data to a data structure
        // then refresh screen
        // TOD O: on builder, instead of 'placeholder' add the
        // custom data structure so that it accepts widgets
        Positioned.fill(
          child: DragTarget<vw.VirtualWidget>(
            onAcceptWithDetails: (details) {
              setState(() {
                tree = Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: details.data.generate());
              });
            },
            // onWillAcceptWithDetails: (details) {
            //   print("Will accept: ${details.data}");
            //   return true;
            // },
            builder: (context, candidateData, rejectedData) => tree,
          ),
        )
      ],
    );
  }
}
