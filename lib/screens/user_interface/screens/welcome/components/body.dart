import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotes/screens/user_interface/components/rounded_button.dart';
import 'package:mynotes/screens/user_interface/screens/constants.dart';
import 'package:mynotes/screens/user_interface/screens/login/login_screen.dart';
import 'package:mynotes/screens/user_interface/screens/signup/signup_screen.dart';
import 'package:mynotes/screens/user_interface/screens/welcome/components/background.dart';

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ));
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
