// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../widgets/widget_button.dart';
import '../widgets/screen.dart';
import '../widgets/screen_controller.dart';
import '../helpers/database/json_loader.dart';

String? currentWidgetFocused;

class EditorScreen extends StatefulWidget {
  final VoidCallback changeTheme;

  const EditorScreen({super.key, required this.changeTheme});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  // Create a GlobalKey to access the state of ScreenController.
  final GlobalKey<ScreenControllerState> _screenControllerKey =
      GlobalKey<ScreenControllerState>();

  /// This function will be passed to the Screen widget.
  /// When the Screen widget is resized, it calls this function with the new width and height.
  /// We then forward that call to the ScreenController via the GlobalKey.
  void changeScreenSizeNotif(String width, String height) {
    _screenControllerKey.currentState?.changeScreenSizeNotif(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor"),
        actions: [
          IconButton(
            onPressed: widget.changeTheme,
            icon: const Icon(Icons.dark_mode),
          )
        ],
      ),
      body: Row(
        children: [
          // Widget properties
          const PropertiesList(),
          // Screen showcase
          Expanded(
            flex: 6,
            child: Column(
              children: [
                // Pass the GlobalKey to ScreenController
                Expanded(
                  flex: 1,
                  child: ScreenController(key: _screenControllerKey),
                ),
                Expanded(
                  flex: 12,
                  child: Center(
                    child: Stack(
                      children: [
                        Screen(
                          initialHeight: 500,
                          initialWidth: 300,
                          changedScreenSizeNotif: changeScreenSizeNotif,
                        ),
                        // TODO: onAccept : add widget data to a data structure
                        // then refresh screen
                        // TODO: on builder, instead of 'placeholder' add the
                        // custom data structure so that it accepts widgets
                        Positioned.fill(
                          child: DragTarget<String>(
                            onAcceptWithDetails: (details) {
                              print("Accepted: ${details.data}");
                            },
                            onWillAcceptWithDetails: (data) {
                              print("Will accept: $data");
                              return true;
                            },
                            builder: (context, candidateData, rejectedData) =>
                                Placeholder(),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // List of widgets
          const WidgetList(),
        ],
      ),
    );
  }
}

class PropertiesList extends StatelessWidget {
  const PropertiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //MARK: PROPERTIES
      flex: 2,
      child: Column(
        children: [
          Center(
            child: Expanded(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  label: Center(child: Text('Search for properties')),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: currentWidgetFocused != null
                ? const Placeholder()
                : Center(
                    child: Text(
                        "No properties found.\nClick on a widget to see properties.")),
          ),
        ],
      ),
    );
  }
}

class WidgetList extends StatelessWidget {
  const WidgetList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //MARK: WIDGET LIST
      flex: 2,
      child: Column(
        children: [
          Center(
            child: Expanded(
              flex: 1,
              child: TextField(
                decoration: const InputDecoration(
                    label: Center(child: Text('Search for a widget'))),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: FutureBuilder<List>(
                  future: getWidgets("lib/assets/widgets.json"),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child:
                              Text("Error loading widgets: ${snapshot.error}"));
                    } else if (snapshot.data != null) {
                      final widgetNames = snapshot.data!;
                      return Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: widgetNames
                            .map((widgetName) =>
                                WidgetButton(name: widgetName.toString()))
                            .toList(),
                      );
                    } else {
                      return const Center(child: Text("No widgets loaded"));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
