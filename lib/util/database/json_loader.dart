import 'dart:io';
import 'dart:convert';
import 'dart:developer';

/// Reads a JSON file from the given path and returns a map of widgets.
///
/// The JSON file must contain a top-level key 'widgets' which maps to a map of strings.
/// If the file cannot be read or parsed, an empty map is returned.
///
/// [path] The path to the JSON file.
///
/// Returns a map of widget names to widget data.
Future<Map<String, String>> getWidgets(String path) async {
  try {
    final file = File(path);
    final fileContent = await file.readAsString();
    final jsonData = jsonDecode(fileContent);

    if (jsonData is Map && jsonData.containsKey('widgets')) {
      final widgets = jsonData['widgets'];
      if (widgets is Map) {
        try {
          return widgets.cast<String, String>();
        } catch (e) {
          log("Error: 'widgets' map contains non-string values. Details: $e");
          return {};
        }
      } else {
        log("Error: The 'widgets' key does not contain a Map.");
        return {};
      }
    } else {
      log("Error: Invalid JSON format or missing 'widgets' key.");
      return {};
    }
  } catch (e) {
    log("Error reading or parsing JSON file: $e");
    return {};
  }
}

// void main() async {
//   // Run the 'ls' command.
//   final result = await Process.run('ls', []);

//   // Check for errors.
//   if (result.exitCode != 0) {
//     print('Error running ls:');
//     print(result.stderr); // Print any error messages from the command
//     return; // Exit the function if there was an error
//   }

//   // Print the standard output of the command.
//   print(result.stdout);
//   // Make main async
//   final widgets =
//       await getWidgets('lib/assets/widgets.json'); // AWAIT the result
//   print(widgets);
// }
