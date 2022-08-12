import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/my_localization.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<void> showCanNotShareEmptyNoteDialog(
  BuildContext context,
  String title,
  String desc,
) async {
  return showGenericDialog(
    context: context,
    title: title,
    content: desc,
    optionsBuilder: () {
      return {context.myloc.ok_button: null};
    },
  );
}
