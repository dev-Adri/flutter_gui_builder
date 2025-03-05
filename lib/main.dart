import 'package:flutter/material.dart';
import './src/screens/editor_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeData theme = ThemeData.dark();

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
