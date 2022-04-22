import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService({required this.provider});

  factory AuthService.firebase(){
    return AuthService(provider: FirebaseAuthProvider());
  }

  @override
  Future<void> initialize() async => provider.initialize();

  @override
  Future<AuthUser> createUser({
    required email,
    required password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
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
}
