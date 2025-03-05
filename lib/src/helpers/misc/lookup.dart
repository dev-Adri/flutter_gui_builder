import './virtual_widget.dart';
import 'package:flutter/material.dart';

final Map<WidgetType, Widget Function()> lookup = {
  WidgetType.container: () => Container()
};