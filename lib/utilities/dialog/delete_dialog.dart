import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/my_localization.dart';
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
        context.myloc.cancel_button: false,
        context.myloc.yes_button: true,
      };
    },
  ).then((value) => value ?? false);
}
