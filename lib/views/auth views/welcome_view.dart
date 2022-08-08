import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotes/constants/constants.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/views/auth%20views/login_view.dart';
import 'package:mynotes/views/auth%20views/register_view.dart';
import 'package:mynotes/views/components/rounded_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomePageBody(),
    );
  }
}

class WelcomeBackground extends StatelessWidget {
  final Widget child;
  const WelcomeBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context)
        .size; // This size will provide total height and width of screen
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

class WelcomePageBody extends StatelessWidget {
  const WelcomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to MyNotes",
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundedButton(
              onTap: () {
                context.read<AuthBloc>().add(const AuthEventLoggingIn());
              },
              title: "LOGIN",
              buttonColor: kPrimaryColor,
              titleColor: Colors.white,
              paddingForRoundedButton: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              ),
            ),
            RoundedButton(
              onTap: () {
                context.read<AuthBloc>().add(
                      const AuthEventShouldCreateAccountOrShouldRegister(),
                    );
              },
              title: "SIGNUP",
              buttonColor: kPrimaryLightColor,
              titleColor: kPrimaryColor,
              paddingForRoundedButton: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
