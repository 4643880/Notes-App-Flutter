import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
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
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  final user = FirebaseAuth.instance.currentUser;
                  final checkNull = user?.emailVerified;     
                  if(checkNull == true){
                    Navigator.pushNamedAndRemoveUntil(context, notesRoute, (route) => false);
                  }else {
                    Navigator.pushNamedAndRemoveUntil(context, emailVerifyRoute, (route) => false);
                  }
                  
                  devtools.log(credential.toString());        
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    devtools.log('No user found for that email.');
                    await showErrorDialog(context, "User Not Found", "No user found for that email. Please try again.");
                  } else if (e.code == 'wrong-password') {
                    devtools.log('Wrong password provided for that user.');
                    await showErrorDialog(context, "Wrong Password", "Wrong password provided for that user. Please try again.");
                  }else{
                    devtools.log(e.code.toString());
                    await showErrorDialog(context, "Something Went Wrong", "Error:  ${e.code}");
                  }
                } catch (e){
                  devtools.log(e.toString());
                    await showErrorDialog(context, "Something Went Wrong", "Error:  $e");

                }
                // print(credential);
              },
              child: const Text("Login")),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed(registerRoute);
          }, child: const Text("Create New Account")),
        ],
      ),
    );
  }
}




Future<void> showErrorDialog(BuildContext context,String myTitle, String myDesc, ){
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(title: Text(myTitle), content: Text(myDesc), actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: const Text("Ok")),
    ],);
  }); 
}