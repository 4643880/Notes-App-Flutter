import 'package:mynotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUserVerification? get currentUser;

  Future<AuthUserVerification> logIn({
    required var email,
    required var password,
  });

  Future<AuthUserVerification> createUser({
    required var email,
    required var password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();
}
