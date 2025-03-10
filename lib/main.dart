import 'package:flutter/material.dart';
import 'screens/editor_screen.dart';

/// The main entry point of the application.
void main() {
  runApp(const MainApp());
}

/// The root widget of the application.
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeData theme = ThemeData.dark();

  /// Toggles the theme between dark and light.
  void changeTheme() {
    setState(() {
      theme = theme == ThemeData.dark() ? ThemeData.light() : ThemeData.dark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: EditorScreen(
          changeTheme: changeTheme,
        ),
        theme: theme);
  }
}
