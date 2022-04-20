import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/verify_email_view.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Home Page")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
            // print("------------------------");
            // print(FirebaseAuth.instance.currentUser);
            // final user = FirebaseAuth.instance.currentUser;
            // final checkVerification = user?.emailVerified ?? false;
            // if (checkVerification == true) {
            //   // print("Your email is verified");
            //   return const Text("Done");
            // } else {
            //   // print("Your email is not verified");
            //   return const VerifyEmailView();
            // }
            //   return const LoginView();
            // default:
            //   return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

