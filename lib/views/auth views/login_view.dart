import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotes/constants/constants.dart';
import 'package:mynotes/extensions/buildcontext/my_localization.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/views/components/rounded_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          devtools.log(state.exception.toString());
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .login_page_userNotFoundAuthException_showErrorDialog_title,
              context.myloc
                  .login_page_userNotFoundAuthException_showErrorDialog_desc,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .login_page_wrongPasswordAuthException_showErrorDialog_title,
              context.myloc
                  .login_page_wrongPasswordAuthException_showErrorDialog_desc,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context
                  .myloc.login_page_genericAuthException_showErrorDialog_title,
              context
                  .myloc.login_page_genericAuthException_showErrorDialog_desc,
            );
          }
        }
      },
      child: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return const Scaffold(
      // appBar: AppBar(),
      body: LoginPageBody(),
    );
  }
}

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _savePassword = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        reverse: true,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.myloc.login_page_title,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            SvgPicture.asset("assets/icons/login.svg"),
            SizedBox(
              height: size.height * 0.04,
            ),
            TextFieldContainer(
              childTextField: TextField(
                controller: _email,
                autocorrect: false,
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: const Icon(
                      Icons.email,
                      color: kPrimaryColor,
                    ),
                    hintText: context.myloc.login_page_email_field),
              ),
            ),
            TextFieldContainer(
              childTextField: TextField(
                controller: _password,
                autocorrect: false,
                autofocus: false,
                enableSuggestions: false,
                onChanged: (value) {},
                obscureText: _savePassword,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: const Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _savePassword = !_savePassword;
                      });
                    },
                    icon: _savePassword
                        ? const Icon(
                            Icons.remove_red_eye,
                            color: kPrimaryColor,
                          )
                        : const Icon(
                            Icons.security,
                            color: kPrimaryColor,
                          ),

                    // Icons.visibility,
                    // color: kPrimaryColor,
                  ),
                  hintText: context.myloc.login_page_password_field,
                  hintStyle: const TextStyle(),
                ),
              ),
            ),
            RoundedButton(
              onTap: () {
                final email = _email.text;
                final password = _password.text;
                BlocProvider.of<AuthBloc>(context).add(
                  AuthEventLogIn(
                    email: email,
                    password: password,
                  ),
                );
              },
              title: context.myloc.login_page_login_button,
              buttonColor: kPrimaryColor,
              titleColor: Colors.white,
              paddingForRoundedButton: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.myloc.login_page_dont_have_acct),
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldCreateAccountOrShouldRegister(),
                        );
                  },
                  child: Text(
                    context.myloc.login_page_signUp_text_button,
                    style: const TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.035,
            ),
            InkWell(
              onTap: () {
                context.read<AuthBloc>().add(
                      const AuthEventForgotPassword(),
                    );
              },
              child: Text(
                context.myloc.login_page_forgot_password,
                style: const TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            // SizedBox(
            //   height: size.height * 0.035,
            // ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailView(),));
            //   },
            //   child: const Text(
            //     "Verify View ?",
            //     style: TextStyle(
            //         color: kPrimaryColor, fontWeight: FontWeight.bold),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget childTextField;
  const TextFieldContainer({
    Key? key,
    required this.childTextField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 20,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: childTextField,
    );
  }
}

class LoginBackground extends StatelessWidget {
  final Widget child;
  const LoginBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/main_top.png"),
            height: size.width * 0.35,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/login_bottom.png"),
            height: size.width * 0.35,
          ),
          child,
        ],
      ),
    );
  }
}


// //==================================================
// TextButton(
//                   onPressed: () async {
//                     final email = _email.text;
//                     final password = _password.text;
//                     BlocProvider.of<AuthBloc>(context).add(AuthEventLogIn(
//                       email: email,
//                       password: password,
//                     ));
//                   },
//                   child: const Text("Login")),
//               TextButton(
//                   onPressed: () {
//                     context
//                         .read<AuthBloc>()
//                         .add(const AuthEventForgotPassword());
//                   },
//                   child: const Text("Forgot Password")),
//               TextButton(
//                   onPressed: () {
//                     context.read<AuthBloc>().add(
//                         const AuthEventShouldCreateAccountOrShouldRegister());
//                   },
//                   child: const Text("Create New Account")),