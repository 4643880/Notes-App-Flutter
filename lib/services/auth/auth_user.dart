// We should not expose user to the UI

// import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

@immutable
class AuthUserVerification {
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUserVerification({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUserVerification.fromFirebase({required User user}) {
    return AuthUserVerification(
      id: user.uid,
      email: user.email!,
      isEmailVerified: user.emailVerified,
    );
  }
}
 