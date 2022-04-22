import 'package:mynotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({required var email, required var password});

  Future<AuthUser> createUser({required var email, required var password});

  Future<void> logOut();

  Future<void> sendEmailVerification();
}
