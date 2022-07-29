import 'package:flutter/material.dart';
import 'package:mynotes/screens/user_interface/screens/login/components/body.dart';
import 'package:mynotes/screens/user_interface/screens/welcome/components/body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return const Scaffold(
      // appBar: AppBar(),
      body: LoginPageBody(),
    );
  }
}
