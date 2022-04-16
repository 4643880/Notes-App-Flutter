import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: "Please Enter Your Email"),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              decoration:
                  const InputDecoration(hintText: "Please Enter Your Password"),
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                  } on FirebaseAuthException catch (e) {
                    print(e);
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    } else if (e.code == "invalid-email") {
                      print("Invalid Email Address");
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text("Sign Up")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, "/login/", (route) => false);                 
                },
                child: const Text("Login Again")),
          ],
        ),
      ),
    );
  }
}
