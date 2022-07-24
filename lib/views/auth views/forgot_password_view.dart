import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';
import 'package:mynotes/utilities/dialog/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _emailController.clear();
            await showPasswordResetSentDialog(
              context: context,
              title: "Password Reset",
              desc:
                  "We have now sent you a password reset link. Please check your email for more information.",
            );
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              "User Not Found",
              "No user found for that email. Please try again.",
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
              "We could not process your request. Please make sure that you are a register user.",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forgot Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  "If you forgot your password, simply enter your email and we'll send you password reset link."),
              TextField(
                controller: _emailController,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: "Please enter address"),
              ),
              TextButton(
                onPressed: () {
                  final email = _emailController.text;
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthEventForgotPassword(email: email));
                },
                child: const Text("Send Me Password Reset Link"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text("Back to Login Page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


        // case 'firebase_auth/invalid-email':
        //   throw InvalidEmailAuthException();
        // case 'firebase_auth/user-not-found':
        //   throw UserNotFoundAuthException();
        // default: 
        //   throw GenericAuthException();