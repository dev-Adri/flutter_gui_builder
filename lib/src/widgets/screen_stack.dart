// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'screen.dart';
import '../helpers/misc/virtual_widget.dart' as vw;

class ScreenStack extends StatefulWidget {
  final Function(String, String) changeScreenSizeNotif;

  const ScreenStack({super.key, required this.changeScreenSizeNotif});

  @override
  State<ScreenStack> createState() => _ScreenStackState();
}

class _ScreenStackState extends State<ScreenStack> {
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
              print("Accepted: ${details.data.generateCode()}");
            },
            onWillAcceptWithDetails: (details) {
              print("Will accept: ${details.data}");
              return true;
            },
            builder: (context, candidateData, rejectedData) => Placeholder(),
          ),
        )
      ],
    );
  }
}
