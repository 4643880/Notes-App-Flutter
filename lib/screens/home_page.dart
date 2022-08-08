import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotes/constants/constants.dart';
import 'package:mynotes/helper/loading/loading_screen.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/views/auth%20views/forgot_password_view.dart';
import 'package:mynotes/views/auth%20views/login_view.dart';
import 'package:mynotes/views/auth%20views/register_view.dart';
import 'package:mynotes/views/auth%20views/verify_email_view.dart';
import 'package:mynotes/views/auth%20views/welcome_view.dart';
import 'package:mynotes/views/components/rounded_button.dart';

import '../views/note views/notes_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<AuthBloc>(context).add(const AuthEventInitialize());
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.isLoadingText ?? "Please wait a moment.");
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const WelcomeView();
        } else if (state is AuthStateLoggingIn) {
          return const LoginView();
        } else if (state is AuthStateWelcome) {
          return const WelcomeView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
