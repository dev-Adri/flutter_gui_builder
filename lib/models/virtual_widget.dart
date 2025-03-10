import 'lookup.dart';
import 'package:flutter/material.dart';

/// Enum representing different types of widgets.
enum WidgetType {
  button,
  text,
  image,
  container,
  row,
  column,
  sizedBox,
  iconButton,
  singleChildScrollView,
  icon
}

/// Extension to parse WidgetType to and from string.
extension Parse on WidgetType {
  /// Converts the WidgetType to a string.
  String toStr() {
    return "${toString().split('.').last[0].toUpperCase()}${toString().split('.').last.substring(1)}";
  }
}

/// Converts a string to a WidgetType.
WidgetType fromStr(String str) {
  return WidgetType.values.byName(str);
}

const List<WidgetType> childrenList = [WidgetType.row, WidgetType.column];

/// Class representing a virtual widget.
class VirtualWidget {
  WidgetType? type;

  VirtualWidget(this.type);

  /// Generates a Flutter widget based on the type.
  Widget generate() {
    return lookup[type]!();
  }

  /// Generates code for a given widget type based on some parameters.
  String generateCode() {
    String defaultChildType = "child";

    // ? Testing this variable (default -> empty)
    List<String> specialCases = [
      /*"mainAxisAlignment: MainAxisAlignment.center"*/
    ];

    if (childrenList.contains(type)) {
      defaultChildType = "children";
    }

    return "${type?.toStr()}(${specialCases.isEmpty ? '' : '${specialCases.join(', ')}, '}$defaultChildType: ${defaultChildType == 'children' ? '[]' : ''})";
  }
}

// Testing the above code
// void main() {
//   print(fromStr("button"));
// }
