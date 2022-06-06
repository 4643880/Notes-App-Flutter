import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

// Function() return type has map
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder, // For Buttons
}) async {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final valuesOfMap = options[optionTitle]; // Keys index get value
          return TextButton(
              onPressed: () {
                if (valuesOfMap != null) {
                  Navigator.of(context).pop(valuesOfMap);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle));
        }).toList(),
      );
    },
  );
}

// Example of dart Related to Generic Dialog
// Map options = { "ali" : 1 , "haider" : 2, "hamza" : 3};

// void main(){
//   print(options.keys.map((optionsTitle) {
//     final valueOfMap = options[optionsTitle];
//     return valueOfMap;

//     },).toList(),
//   );
// }
