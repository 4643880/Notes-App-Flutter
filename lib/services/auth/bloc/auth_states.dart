
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  // If you create const constructor of parent class then child classes will also ask for const keyword.
  const AuthState();
}


// class AuthStateUninitialized extends AuthState {
//   const AuthStateUninitialized();
// }


class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}




class AuthStateLoggedIn extends AuthState {
  final Exception? exception;
  final AuthUserVerification user;
  

  const AuthStateLoggedIn(this.exception, {required this.user});
}



class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();

}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isInitializing;

  const AuthStateLoggedOut(this.exception, {required this.isInitializing});

  @override
  List<Object?> get props => [exception, isInitializing];
}



class AuthStateRegistering extends AuthState{
  final Exception? exception;

  const AuthStateRegistering (this.exception);

}

// class AuthStateForError extends AuthState{
//   final Exception? exception;

//   AuthStateForError({this.exception});

// }