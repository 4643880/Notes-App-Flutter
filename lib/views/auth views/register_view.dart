import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedsVerification) {
          await showErrorDialog(
            context,
            "Verify Your Email",
            "We have sent verification email.",
          );
        } else if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              "Weak Password",
              "The password provided is too weak.",
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              "Email Already in Use",
              "The account already exists for that email.",
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "Invalid Email Address",
              "Please Enter Correct Email Address it's Invalid",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Something Went Wrong",
              "Error: Failed to register.",
            );
          }
        }
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(title: const Text("Register")),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: true,
                  autocorrect: true,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: "Please Enter Your Email"),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  autocorrect: false,
                  autofocus: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                      hintText: "Please Enter Your Password"),
                ),
                TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      context.read<AuthBloc>().add(
                            AuthEventRegister(
                              email: email,
                              password: password,
                            ),
                          );
                    },
                    child: const Text("Sign Up")),
                TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: const Text("Back to Login Page")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
