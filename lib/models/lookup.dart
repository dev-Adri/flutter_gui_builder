import 'virtual_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/labeled_border_widget.dart'; // Import the new widget

final Map<WidgetType, Widget Function()> lookup = {
  WidgetType.container: () => LabeledBorderWidget(
        label: 'Container',
        borderColor: Colors.red,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Placeholder()),
      ),
  WidgetType.column: () => LabeledBorderWidget(
        label: 'Column',
        borderColor: Colors.blue,
        child: Column(
          children: [],
        ),
      )
  // Add more widgets here
};
