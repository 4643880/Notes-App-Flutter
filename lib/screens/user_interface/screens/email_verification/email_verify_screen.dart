


import 'package:flutter/material.dart';
import 'package:mynotes/screens/user_interface/screens/email_verification/components/body.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmailVerificationBody(),
    );
  }
}



