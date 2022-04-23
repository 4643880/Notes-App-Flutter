// We should not expose user to the UI

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUserVerification {
  final bool isEmailVerified;
  const AuthUserVerification({required this.isEmailVerified});

  factory AuthUserVerification.fromFirebase({required User user}) {
    return AuthUserVerification(isEmailVerified: user.emailVerified);
  }
}
