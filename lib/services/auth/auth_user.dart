// We should not expose user to the UI

// import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

@immutable
class AuthUserVerification {
  final String? email;
  final bool isEmailVerified;
  const AuthUserVerification({
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUserVerification.fromFirebase({required User user}) {
    return AuthUserVerification(
      email: user.email,
      isEmailVerified: user.emailVerified,
    );
  }
}
