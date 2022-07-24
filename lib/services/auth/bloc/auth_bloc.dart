import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required FirebaseAuthProvider provider})
      : super(const AuthStateInitial(isLoading: true)) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(null, user: user, isLoading: false));
      }
    });

    // Login
    on<AuthEventLogIn>((event, emit) async {
      // Displaying Dialog
      emit(const AuthStateLoggedOut(null,
          isLoading: true, isLoadingText: "Please wait a moment."));

      // await Future.delayed(const Duration(seconds: 8));

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          // Disable Loading
          emit(const AuthStateLoggedOut(
            null,
            isLoading: false,
          ));

          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          // Disable Loading
          emit(const AuthStateLoggedOut(
            null,
            isLoading: false,
          ));

          emit(AuthStateLoggedIn(null, user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e,
            isLoading: false, isLoadingText: "Please wait a moment."));
      }
    });

    // Logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e, isLoading: false));
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
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(e, isLoading: false));
      }
    });

    // Email Verificaiton
    on<AuthEventSendVerificationEmail>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // Forgot Password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));

      final gettingEmail = event.email;
      if (gettingEmail == null) {
        return; // User wants to go to forgot password screen;
      }

      // Now User Wants to send forgot password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: gettingEmail);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;

        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ));
      }
    });

    on<AuthEventShouldCreateAccountOrShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        null,
        isLoading: false,
      ));
    });
  }
}
