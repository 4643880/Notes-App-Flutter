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
import 'package:mynotes/views/components/rounded_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedsVerification) {
          await showErrorDialog(
            context,
            context.myloc
                .signup_page_authStateNeedsVerification_showErrorDialog_title,
            context.myloc
                .signup_page_authStateNeedsVerification_showErrorDialog_desc,
          );
        } else if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .signup_page_weakPasswordAuthException_showErrorDialog_title,
              context.myloc
                  .signup_page_weakPasswordAuthException_showErrorDialog_desc,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .signup_page_emailAlreadyInUseAuthException_showErrorDialog_title,
              context.myloc
                  .signup_page_emailAlreadyInUseAuthException_showErrorDialog_desc,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .signup_page_invalidEmailAuthException_showErrorDialog_title,
              context.myloc
                  .signup_page_invalidEmailAuthException_showErrorDialog_desc,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context
                  .myloc.signup_page_genericAuthException_showErrorDialog_title,
              context
                  .myloc.signup_page_genericAuthException_showErrorDialog_desc,
            );
          }
        }
      },
      child: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignUpBody(),
    );
  }
}

class SignUpBackground extends StatelessWidget {
  final Widget child;
  const SignUpBackground({
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
            child: Image.asset(
              "assets/images/signup_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.2,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class SignUpBody extends StatefulWidget {
  const SignUpBody({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
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
    return SignUpBackground(
      child: SingleChildScrollView(
        reverse: true,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.025,
            ),
            Text(
              context.myloc.signup_page_title,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            SvgPicture.asset("assets/icons/signup.svg",
                height: size.height * 0.35),
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
                    hintText: context.myloc.signup_page_email_field),
              ),
            ),
            TextFieldContainer(
              childTextField: TextField(
                controller: _password,
                autocorrect: false,
                autofocus: false,
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
                  ),
                  hintText: context.myloc.signup_page_password_field,
                  hintStyle: const TextStyle(),
                ),
              ),
            ),
            RoundedButton(
              onTap: () {
                final email = _email.text;
                final password = _password.text;

                context.read<AuthBloc>().add(
                      AuthEventRegister(
                        email: email,
                        password: password,
                      ),
                    );
              },
              title: context.myloc.signup_page_signup_button,
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
                Text(context.myloc.signup_page_already_have_acct),
                InkWell(
                    onTap: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(const AuthEventLoggingIn());
                    },
                    child: Text(
                      context.myloc.signup_page_login_text_button,
                      style: const TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            const OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: kPrimaryLightColor),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      "assets/icons/facebook.svg",
                      color: kPrimaryColor,
                      height: size.height * 0.03,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: kPrimaryLightColor),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      "assets/icons/twitter.svg",
                      color: kPrimaryColor,
                      height: size.height * 0.03,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: kPrimaryLightColor),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      "assets/icons/google-plus.svg",
                      color: kPrimaryColor,
                      height: size.height * 0.03,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
          ],
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Color(0xffd9d9d9),
              thickness: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              context.myloc.signup_page_orDivider,
              style: const TextStyle(
                  fontWeight: FontWeight.w900, color: kPrimaryColor),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Color(0xffd9d9d9),
              thickness: 2,
            ),
          ),
        ],
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



//===============================
                // TextButton(
                //     onPressed: () async {
                      // final email = _email.text;
                      // final password = _password.text;

                      // context.read<AuthBloc>().add(
                      //       AuthEventRegister(
                      //         email: email,
                      //         password: password,
                      //       ),
                      //     );
                //     },
                //     child: const Text("Sign Up")),
                // TextButton(
                //     onPressed: () {
                //       context.read<AuthBloc>().add(
                //             const AuthEventLogOut(),
                //           );
                //     },
                //     child: const Text("Back to Login Page")),