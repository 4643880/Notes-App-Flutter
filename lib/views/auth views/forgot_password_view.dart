import 'package:flutter/cupertino.dart';
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
import 'package:mynotes/utilities/dialog/password_reset_email_sent_dialog.dart';
import 'package:mynotes/views/components/rounded_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            // _emailController.clear();
            await showPasswordResetSentDialog(
              context: context,
              title: context
                  .myloc.forgotPassword_page_showPasswordResetSentDialog_title,
              desc: context
                  .myloc.forgotPassword_page_showPasswordResetSentDialog_desc,
            );
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .forgotPassword_page_userNotFoundAuthException_showErrorDialog_title,
              context.myloc
                  .forgotPassword_page_userNotFoundAuthException_showErrorDialog_desc,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .forgotPassword_page_invalidEmailAuthException_showErrorDialog_title,
              context.myloc
                  .forgotPassword_page_invalidEmailAuthException_showErrorDialog_desc,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.myloc
                  .forgotPassword_page_genericAuthException_showErrorDialog_title,
              context.myloc
                  .forgotPassword_page_genericAuthException_showErrorDialog_desc,
            );
          }
        }
      },
      child: const ForgotPasswordScreen(),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ForgotPaswordBody(),
    );
  }
}

class ForgotPasswordBackground extends StatelessWidget {
  final Widget child;
  const ForgotPasswordBackground({
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
              "assets/images/main_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class ForgotPaswordBody extends StatefulWidget {
  const ForgotPaswordBody({Key? key}) : super(key: key);

  @override
  State<ForgotPaswordBody> createState() => _ForgotPaswordBodyState();
}

class _ForgotPaswordBodyState extends State<ForgotPaswordBody> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ForgotPasswordBackground(
      child: SingleChildScrollView(
        reverse: true,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.myloc.forgotPassword_page_title,
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: const Icon(
                      Icons.email,
                      color: kPrimaryColor,
                    ),
                    hintText: context.myloc.forgotPassword_page_email_field),
              ),
            ),
            RoundedButton(
              onTap: () {
                final email = _emailController.text;
                BlocProvider.of<AuthBloc>(context)
                    .add(AuthEventForgotPassword(email: email));
              },
              title: context.myloc.forgotPassword_page_Send_button,
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
                Text(context.myloc.forgotPassword_page_goBack_title),
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLoggingIn(),
                        );
                  },
                  child: Text(
                    context.myloc.forgotPassword_page_login_text_button,
                    style: const TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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



//======================================
// TextButton(
//                 onPressed: () {
                  // final email = _emailController.text;
                  // BlocProvider.of<AuthBloc>(context)
                  //     .add(AuthEventForgotPassword(email: email));
//                 },
//                 child: const Text("Send Me Password Reset Link"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   context.read<AuthBloc>().add(const AuthEventLogOut());
//                 },
//                 child: const Text("Back to Login Page"),
//               ),