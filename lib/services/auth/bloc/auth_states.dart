import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  // If you create const constructor of parent class then child classes will also ask for const keyword.
  final bool isLoading;
  final String? isLoadingText;

  const AuthState({
    required this.isLoading,
    this.isLoadingText = "Please wait a moment.",
  });
}

// class AuthStateUninitialized extends AuthState {
//   const AuthStateUninitialized();
// }

class AuthStateInitial extends AuthState {
  const AuthStateInitial({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final Exception? exception;
  final AuthUserVerification user;

  const AuthStateLoggedIn(this.exception,
      {required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut(this.exception,
      {required bool isLoading, String? isLoadingText})
      : super(isLoading: isLoading, isLoadingText: isLoadingText);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering(this.exception, {required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}
// class AuthStateForError extends AuthState{
//   final Exception? exception;

//   AuthStateForError({this.exception});

// }