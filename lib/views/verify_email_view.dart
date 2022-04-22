import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Verify Your Email", style: TextStyle(fontWeight: FontWeight.w600), textScaleFactor: 2.5),
            const SizedBox(height: 10,),
            const Text("If you did'nt receive verification email yet. Please click the button below.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
            const SizedBox(height: 10,),
            ElevatedButton(                     
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();

                  await showErrorDialog(context, "Verify Your Email", "We have sent you verification email again.");

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child:  Text("Verify", textScaleFactor: 1.4,),
                )),
            ElevatedButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);

            }, child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child:  Text("Restart", textScaleFactor: 1.4,),
                )),
          ]),
        ),
      ),
    );
  }
}
