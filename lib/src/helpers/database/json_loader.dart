import 'dart:io';
import 'dart:convert';
import 'dart:developer';

Future<List> getWidgets(String path) async {
  // Make the function async
  try {
    final file = File(path);
    final fileContent = await file.readAsString(); // AWAIT the file read
    final jsonData = jsonDecode(fileContent);

    if (jsonData is Map && jsonData.containsKey('widgets')) {
      final widgetsList = jsonData['widgets'];
      if (widgetsList is List) {
        return widgetsList;
      } else {
        log("Error: The 'widgets' key does not contain a List.");
        return [];
      }
    } else {
      log("Error: Invalid JSON format.");
      return [];
    }
  } catch (e) {
    log("Error reading or parsing JSON file: $e");
    return [];
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
