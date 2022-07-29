import 'package:flutter/material.dart';
import 'package:mynotes/screens/user_interface/screens/welcome/components/body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomePageBody(),
      
    );
  }
}