import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';

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
                  await AuthService.firebase()
                      .logIn(email: email, password: password);
                  final user = AuthService.firebase().currentUser;
                  final checkNull = user?.isEmailVerified;
                  if (checkNull == true) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, notesRoute, (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, emailVerifyRoute, (route) => false);
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(context, "User Not Found",
                      "No user found for that email. Please try again.");
                } on WrongPasswordAuthException {
                  await showErrorDialog(context, "Wrong Password",
                      "Wrong password provided for that user. Please try again.");
                } on GenericAuthException {
                  await showErrorDialog(context, "Something Went Wrong",
                      "Error:  Authentication Error");
                }
                NotesService obj = NotesService();
                await obj.cacheNotes();

                //  on FirebaseAuthException catch (e) {
                //   if (e.code == 'user-not-found') {
                //     devtools.log('No user found for that email.');
                //     await showErrorDialog(context, "User Not Found", "No user found for that email. Please try again.");
                //   } else if (e.code == 'wrong-password') {
                //     devtools.log('Wrong password provided for that user.');
                //     await showErrorDialog(context, "Wrong Password", "Wrong password provided for that user. Please try again.");
                //   }else{
                //     devtools.log(e.code.toString());
                //     await showErrorDialog(context, "Something Went Wrong", "Error:  ${e.code}");
                //   }
                // } catch (e){
                //   devtools.log(e.toString());
                //     await showErrorDialog(context, "Something Went Wrong", "Error:  $e");

                // }
                // print(credential);
              },
              child: const Text("Login")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(registerRoute);
              },
              child: const Text("Create New Account")),
        ],
      ),
    );
  }
}
