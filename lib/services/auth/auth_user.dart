// We should not expose user to the UI

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser{
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase({required User user}) {
    return AuthUser(isEmailVerified: user.emailVerified);
  }

}