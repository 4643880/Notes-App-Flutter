import 'package:flutter/cupertino.dart';
import 'package:mynotes/extensions/buildcontext/my_localization.dart';
import 'package:mynotes/utilities/dialog/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(
    {required BuildContext context,
    required String title,
    required String desc}) {
  return showGenericDialog(
    context: context,
    title: title,
    content: desc,
    optionsBuilder: () {
      return {context.myloc.ok_button: null};
    },
  );
}


// Password Reset 
// We have now sent you a password reset link. Please check your email for more information.