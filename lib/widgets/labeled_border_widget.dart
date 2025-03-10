import 'package:flutter/material.dart';

/// A widget that wraps its [child] with a dashed border and displays a [label].
///
/// Use this widget to highlight or annotate a widget with a customizable dashed border.
class LabeledBorderWidget extends StatelessWidget {
  /// The widget to display inside the border.
  final Widget child;

  /// The text label that appears above the border.
  final String label;

  /// The color for both the dashed border and the label text.
  final Color borderColor;

  const LabeledBorderWidget({
    super.key,
    required this.child,
    required this.label,
    this.borderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: ShapeDecoration(
            shape: DashBorder(
              color: borderColor,
              width: 1.0,
            ),
          ),
          child: child,
        ),
        Positioned(
          top: -10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.white,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: borderColor),
            ),
          ),
        ),
      ],
    );
  }
}

/// A custom dashed border shape used by [LabeledBorderWidget].
class DashBorder extends ShapeBorder {
  /// The color of the dashes.
  final Color color;

  /// The thickness of the border.
  final double width;

  /// A pattern indicating the lengths of dashes and gaps.
  final List<double> dashPattern;

  const DashBorder({
    required this.color,
    required this.width,
    this.dashPattern = const [3, 3],
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect.deflate(width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final path = Path()..addRect(rect.deflate(width / 2));
    final dashPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final dashLength = dashPattern[0];
        final gapLength = dashPattern[1];
        dashPath.addPath(
          metric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gapLength;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return DashBorder(
      color: color,
      width: width * t,
      dashPattern: dashPattern,
    );
  }
}
