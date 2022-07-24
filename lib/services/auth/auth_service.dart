import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final FirebaseAuthProvider provider;
  AuthService({required this.provider});

  factory AuthService.firebase() {
    return AuthService(provider: FirebaseAuthProvider());
  }

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUserVerification> createUser({
    required email,
    required password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUserVerification? get currentUser => provider.currentUser;

  @override
  Future<AuthUserVerification> logIn({
    required email,
    required password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) => provider.sendPasswordReset(toEmail: toEmail);
}
