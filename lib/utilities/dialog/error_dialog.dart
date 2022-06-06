import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String title,
  String desc,
) async {
  return await showGenericDialog(
    context: context,
    title: title,
    content: desc,
    optionsBuilder: (){
      return {"Ok" : null};
    },
  );
}
