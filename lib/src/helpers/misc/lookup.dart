import './virtual_widget.dart';
import 'package:flutter/material.dart';

final Map<WidgetType, Widget Function()> lookup = {
  WidgetType.container: () => Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            BoxDecoration(border: Border.all(width: 2.0, color: Colors.red)),
      ),
};
