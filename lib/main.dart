import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/screens/home_page.dart';
import 'package:mynotes/screens/home_page_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/auth%20views/login_view.dart';
import 'package:mynotes/views/auth%20views/register_view.dart';
import 'package:mynotes/views/auth%20views/verify_email_view.dart';
import 'package:mynotes/views/note%20views/create_update_note_view.dart';
import 'package:mynotes/views/note%20views/notes_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      //   DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(), // Wrap your app
      // ),
      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: {
        "/": (context) => BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(provider: FirebaseAuthProvider()),
              child: const HomePage(),
            ),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        emailVerifyRoute: (context) => const VerifyEmailView(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}
