import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required FirebaseAuthProvider provider}) : super(const AuthStateLoading()) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user: user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        emit(AuthStateLoggedIn(user: user));
      } on Exception catch (e) {
        emit(AuthStateLoginFailure(e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e){
        emit(AuthStateLogOutFailure(e));
      }
    });
  }
}
