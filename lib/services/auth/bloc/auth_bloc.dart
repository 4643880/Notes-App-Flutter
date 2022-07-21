import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required FirebaseAuthProvider provider})
      : super(const AuthStateInitial()) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          null,
          isInitializing: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(
          null,
          user: user,
        ));
      }
    });

    // Login
    on<AuthEventLogIn>((event, emit) async {
      // Displaying Dialog
      emit(const AuthStateLoggedOut(null, isInitializing: true));

      await Future.delayed(const Duration(seconds: 8));

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          // Disable Loading
          emit(const AuthStateLoggedOut(null, isInitializing: false));

          emit(const AuthStateNeedsVerification());
        } else {
          // Disable Loading
          emit(const AuthStateLoggedOut(null, isInitializing: false));

          emit(AuthStateLoggedIn(null, user: user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e, isInitializing: false));
      }
    });

    // Logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null, isInitializing: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e, isInitializing: false));
      }
    });

    // Register
    on<AuthEventRegister>((event, emit) async {
      try {
        final email = event.email;
        final password = event.password;
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    // Email Verificaiton
    on<AuthEventSendVerificationEmail>((event, emit) async {
      provider.sendEmailVerification();
      emit(state);
    });
  }
}
