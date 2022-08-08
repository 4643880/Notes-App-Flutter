import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotes/constants/constants.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/auth/bloc/auth_states.dart';
import 'package:mynotes/utilities/dialog/error_dialog.dart';
import 'package:mynotes/views/components/rounded_button.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return const EmailVerificationScreen();
  }
}



class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmailVerificationBody(),
    );
  }
}



class EmailVerificationBackground extends StatelessWidget {
  final Widget child;
  const EmailVerificationBackground({
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



class EmailVerificationBody extends StatelessWidget {
  const EmailVerificationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return EmailVerificationBackground(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please Verify Your Email",
              style: TextStyle(
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
            const Text(
              "If you did'nt receive email yet. Please click the button below.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            RoundedButton(
              onTap: () {
                context.read<AuthBloc>().add(const AuthEventSendVerificationEmail());
              },
              title: "Send Me",
              buttonColor: kPrimaryColor,
              titleColor: Colors.white,
              paddingForRoundedButton: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
              ),
            ),
            RoundedButton(
              onTap: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              title: "Restart",
              buttonColor: const Color.fromARGB(255, 228, 209, 253),
              titleColor: kPrimaryColor,
              paddingForRoundedButton: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
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



//==========================
// ElevatedButton(
//                 onPressed: () async {

//                   context.read<AuthBloc>().add(const AuthEventSendVerificationEmail());
                  
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 6,
//                   ),
//                   child: Text(
//                     "Verify",
//                     textScaleFactor: 1.4,
//                   ),
//                 )),
//             ElevatedButton(
//                 onPressed: () async {
//                   context.read<AuthBloc>().add(const AuthEventLogOut());
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
//                   child: Text(
//                     "Restart",
//                     textScaleFactor: 1.4,
//                   ),
//                 )),