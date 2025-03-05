import 'package:flutter/material.dart';

import '../helpers/misc/virtual_widget.dart' as vw;

class WidgetButton extends StatefulWidget {
  final String name;
  final String id;

  const WidgetButton({super.key, required this.name, required this.id});

  @override
  State<WidgetButton> createState() => _WidgetButtonState();
}

class _WidgetButtonState extends State<WidgetButton> {
  bool _isHovering = false;

  void _setHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.move,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: Draggable<vw.VirtualWidget>(
        // Data carried during drag
        data: vw.VirtualWidget(vw.fromStr(widget.id)),
        // "Ghost" widget shown during dragging
        feedback: _ButtonFeedback(name: widget.name),
        // Placeholder shown in original spot during dragging
        childWhenDragging: _ButtonPlaceholder(name: widget.name),
        // Original button when not dragging
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            color: _isHovering ? Colors.grey[700] : Colors.grey[400],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(widget.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}

// "Ghost" version of the button during dragging
class _ButtonFeedback extends StatelessWidget {
  final String name;

  const _ButtonFeedback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7, // Semi-transparent for ghost effect
      child: Container(
        width: 90.0,
        height: 90.0,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Placeholder version of the button when dragging
class _ButtonPlaceholder extends StatelessWidget {
  final String name;

  const _ButtonPlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      height: 90.0,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light gray for placeholder
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500]), // Faded text
        ),
      ),
    );
  }
}
