import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';
import 'package:mynotes/utilities/dialog/loading_dialog.dart';
import 'dart:developer' as devtools show log;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        devtools.log(state.toString());
        if (state is AuthStateLoggedOut) {
          devtools.log(state.exception.toString());
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, "User Not Found",
                "No user found for that email. Please try again.");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, "Wrong Password",
                "Wrong password provided for that user. Please try again.");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Something Went Wrong",
                "Error:  Authentication Error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Text(
                  "Please login to your account in order to interect with and create notes."),
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
                decoration: const InputDecoration(
                    hintText: "Please Enter Your Password"),
              ),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    BlocProvider.of<AuthBloc>(context).add(AuthEventLogIn(
                      email: email,
                      password: password,
                    ));
                  },
                  child: const Text("Login")),
              TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventForgotPassword());
                  },
                  child: const Text("Forgot Password")),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                        const AuthEventShouldCreateAccountOrShouldRegister());
                  },
                  child: const Text("Create New Account")),
            ],
          ),
        ),
      ),
    );
  }
}
