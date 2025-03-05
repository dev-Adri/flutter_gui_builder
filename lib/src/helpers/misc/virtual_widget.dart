import 'lookup.dart';
import 'package:flutter/material.dart';

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

extension Parse on WidgetType {
  String toStr() {
    return "${toString().split('.').last[0].toUpperCase()}${toString().split('.').last.substring(1)}";
  }
}

WidgetType fromStr(String str) {
  return WidgetType.values.byName(str);
}

const List<WidgetType> childrenList = [WidgetType.row, WidgetType.column];

class VirtualWidget {
  WidgetType? type;

  VirtualWidget(this.type);

  Widget generate() {
    return lookup[type]!();
  }

  // Generates code for a given widget type based on some parameters
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
