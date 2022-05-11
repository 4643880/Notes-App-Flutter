import 'dart:math';

import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    test("Should Not be Initialize in beginning", () {
      expect(provider.isInitialize, false);
    });

    test("Can not log out if not initialize", () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test("Should be able to initialize" , ()async{
      await provider.initialize();
      expect(provider._isInitialize,true);
    });





  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialize = false;
  bool get isInitialize {
    return _isInitialize;
  }

  AuthUserVerification? _user;

  @override
  Future<AuthUserVerification> createUser({
    required email,
    required password,
  }) async {
    if (!isInitialize) {
      throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  AuthUserVerification? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialize = true;
  }

  @override
  Future<AuthUserVerification> logIn({
    required email,
    required password,
  }) {
    if (!isInitialize) {
      throw NotInitializedException();
    }
    if (email == "alpha@gmail.com") {
      throw UserNotFoundAuthException();
    }
    if (password == 12345678) throw WrongPasswordAuthException();

    const user = AuthUserVerification(isEmailVerified: false);
    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialize) {
      throw NotInitializedException();
    }
    if (_user == null) {
      throw UserNotFoundAuthException();
    }
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialize) {
      throw NotInitializedException();
    }
    if (_user == null) {
      throw UserNotFoundAuthException();
    }
    const newUser = AuthUserVerification(isEmailVerified: true);
    _user = newUser;
  }
}
