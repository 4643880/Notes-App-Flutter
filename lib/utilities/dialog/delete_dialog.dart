import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
  String title,
  String desc,
) async {
  return await showGenericDialog<bool>(
    context: context,
    title: title,
    content: desc,
    optionsBuilder: () {
      return {
        "Cancel": false,
        "Yes": true,
      };
    },
  ).then((value) => value ?? false);
}
