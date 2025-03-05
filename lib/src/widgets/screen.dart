import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that represents a resizable screen area.
///
/// The [Screen] widget allows users to interactively resize the screen by
/// dragging its edges or corners. It provides a callback [changedScreenSizeNotif]
/// that is called on every frame during resizing with the updated dimensions.
class Screen extends StatefulWidget {
  /// The initial width of the screen.
  final double initialWidth;

  /// The initial height of the screen.
  final double initialHeight;

  /// The child widget to display inside the resizable area.
  final Widget? child;

  /// Callback function that notifies when the screen size changes.
  ///
  /// The function takes two parameters: the new width and height as strings.
  final Function(String, String) changedScreenSizeNotif;

  /// Creates a [Screen] widget.
  const Screen({
    super.key,
    this.initialWidth = 100.0,
    this.initialHeight = 100.0,
    required this.changedScreenSizeNotif,
    this.child,
  });

  @override
  ScreenState createState() => ScreenState();
}

/// Enum representing the possible directions in which the screen can be resized.
enum ResizeDirection {
  none,
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// The state for the [Screen] widget.
class ScreenState extends State<Screen> {
  /// The current width of the screen.
  late double _width;

  /// The current height of the screen.
  late double _height;

  /// The current hover direction based on the mouse position.
  ResizeDirection _hoverResizeDirection = ResizeDirection.none;

  /// The current resize direction during dragging.
  ResizeDirection _resizeDirection = ResizeDirection.none;

  /// Minimum allowed width for the screen.
  final double minWidth = 50.0;

  /// Minimum allowed height for the screen.
  final double minHeight = 50.0;

  /// Sensitivity in pixels for detecting the edge proximity.
  final double edgeSensitivity = 10.0;

  @override
  void initState() {
    super.initState();
    _width = widget.initialWidth;
    _height = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Colors.white : Colors.black;

    return MouseRegion(
      onHover: (event) {
        // Update hover direction based on mouse position.
        _updateHoverResizeDirection(event.localPosition);
      },
      cursor: _getCursorForDirection(_hoverResizeDirection),
      child: GestureDetector(
        onPanStart: (details) {
          // Determine the initial resize direction when dragging starts.
          _determineResizeDirection(details.localPosition);
        },
        onPanUpdate: (details) {
          // If a valid resize direction is set, update the size of the screen
          // and notify the parent widget about the size change.
          if (_resizeDirection != ResizeDirection.none) {
            _resizeBox(details.delta);
          }
        },
        onPanEnd: (details) {
          // Reset the resize direction after dragging ends.
          setState(() {
            _resizeDirection = ResizeDirection.none;
          });
        },
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: widget.child,
        ),
      ),
    );
  }

  /// Updates the hover resize direction based on the current mouse position.
  ///
  /// [localPosition] The position of the mouse relative to the widget.
  void _updateHoverResizeDirection(Offset localPosition) {
    setState(() {
      _hoverResizeDirection = _calculateResizeDirection(localPosition);
    });
  }

  /// Determines the resize direction at the start of a drag gesture.
  ///
  /// [localPosition] The starting position of the drag relative to the widget.
  void _determineResizeDirection(Offset localPosition) {
    setState(() {
      _resizeDirection = _calculateResizeDirection(localPosition);
    });
  }

  /// Calculates the resize direction based on the proximity of [localPosition]
  /// to the widget's edges.
  ///
  /// Returns a [ResizeDirection] indicating which edge or corner is being hovered or dragged.
  ResizeDirection _calculateResizeDirection(Offset localPosition) {
    // Check proximity to edges.
    bool nearLeftEdge = localPosition.dx < edgeSensitivity;
    bool nearRightEdge = _width - localPosition.dx < edgeSensitivity;
    bool nearTopEdge = localPosition.dy < edgeSensitivity;
    bool nearBottomEdge = _height - localPosition.dy < edgeSensitivity;

    if (nearTopEdge && nearLeftEdge) {
      return ResizeDirection.topLeft;
    } else if (nearTopEdge && nearRightEdge) {
      return ResizeDirection.topRight;
    } else if (nearBottomEdge && nearLeftEdge) {
      return ResizeDirection.bottomLeft;
    } else if (nearBottomEdge && nearRightEdge) {
      return ResizeDirection.bottomRight;
    } else if (nearTopEdge) {
      return ResizeDirection.top;
    } else if (nearBottomEdge) {
      return ResizeDirection.bottom;
    } else if (nearLeftEdge) {
      return ResizeDirection.left;
    } else if (nearRightEdge) {
      return ResizeDirection.right;
    } else {
      return ResizeDirection.none;
    }
  }

  /// Resizes the widget based on the [delta] from the drag gesture.
  ///
  /// This method adjusts [_width] and [_height] based on the current [_resizeDirection].
  /// After the dimensions are updated, it calls [widget.changedScreenSizeNotif]
  /// with the new width and height as strings, notifying the parent widget.
  void _resizeBox(Offset delta) {
    setState(() {
      switch (_resizeDirection) {
        case ResizeDirection.top:
          _height -= delta.dy;
          _height = _height.clamp(minHeight, double.infinity);
          break;
        case ResizeDirection.bottom:
          _height += delta.dy;
          _height = _height.clamp(minHeight, double.infinity);
          break;
        case ResizeDirection.left:
          _width -= delta.dx;
          _width = _width.clamp(minWidth, double.infinity);
          break;
        case ResizeDirection.right:
          _width += delta.dx;
          _width = _width.clamp(minWidth, double.infinity);
          break;
        case ResizeDirection.topLeft:
          _width -= delta.dx;
          _height -= delta.dy;
          _width = _width.clamp(minWidth, double.infinity);
          _height = _height.clamp(minHeight, double.infinity);
          break;
        case ResizeDirection.topRight:
          _width += delta.dx;
          _height -= delta.dy;
          _width = _width.clamp(minWidth, double.infinity);
          _height = _height.clamp(minHeight, double.infinity);
          break;
        case ResizeDirection.bottomLeft:
          _width -= delta.dx;
          _height += delta.dy;
          _width = _width.clamp(minWidth, double.infinity);
          _height = _height.clamp(minHeight, double.infinity);
          break;
        case ResizeDirection.bottomRight:
          _width += delta.dx;
          _height += delta.dy;
          _width = _width.clamp(minWidth, double.infinity);
          _height = _height.clamp(minHeight, double.infinity);
          break;
        case ResizeDirection.none:
          break;
      }
      // Notify the parent widget with the updated width and height (as strings)
      // on every frame during resizing.
      widget.changedScreenSizeNotif(
          _width.toInt().toString(), _height.toInt().toString());
    });
  }

  /// Returns the appropriate mouse cursor based on the given [direction].
  ///
  /// [direction] The current resize direction.
  /// Returns a [SystemMouseCursor] corresponding to the direction.
  SystemMouseCursor _getCursorForDirection(ResizeDirection direction) {
    switch (direction) {
      case ResizeDirection.top:
      case ResizeDirection.bottom:
        return SystemMouseCursors.resizeRow;
      case ResizeDirection.left:
      case ResizeDirection.right:
        return SystemMouseCursors.resizeColumn;
      case ResizeDirection.topLeft:
      case ResizeDirection.bottomRight:
        return SystemMouseCursors.resizeUpLeftDownRight;
      case ResizeDirection.topRight:
      case ResizeDirection.bottomLeft:
        return SystemMouseCursors.resizeUpRightDownLeft;
      default:
        return SystemMouseCursors.basic;
    }
  }
}
