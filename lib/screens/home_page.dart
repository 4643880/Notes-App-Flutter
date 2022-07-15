import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/blocs/auth_states.dart';
import 'package:mynotes/views/auth%20views/login_view.dart';
import 'package:mynotes/views/auth%20views/verify_email_view.dart';

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
    return BlocBuilder(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );


  }
}
