import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 12,
        ),
        Text(text),
      ],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return dialog;
    },
  );


  return () => Navigator.of(context).pop();


}
