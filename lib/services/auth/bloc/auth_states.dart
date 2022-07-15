
import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  // If you create const constructor of parent class then child classes will also ask for const keyword.
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUserVerification user;

  const AuthStateLoggedIn({required this.user});
}

class AuthStateForError extends AuthState{
  final Exception? exception;

  AuthStateForError({this.exception});

}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();

}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({this.exception});
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;

  const AuthStateLogOutFailure(this.exception);
}