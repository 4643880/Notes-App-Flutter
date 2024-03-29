// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mynotes/screens/user_interface/components/rounded_button.dart';
// import 'package:mynotes/constants/constants.dart';
// import 'package:mynotes/screens/user_interface/screens/login/components/background.dart';
// import 'package:mynotes/screens/user_interface/screens/signup/signup_screen.dart';
// import 'package:mynotes/screens/user_interface/screens/welcome/components/background.dart';

// class LoginPageBody extends StatelessWidget {
//   const LoginPageBody({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return LoginBackground(
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(
//           parent: BouncingScrollPhysics(),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "LOGIN",
//               style: TextStyle(
//                 color: kPrimaryColor,
//                 fontSize: 25,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             SizedBox(
//               height: size.height * 0.04,
//             ),
//             SvgPicture.asset("assets/icons/login.svg"),
//             SizedBox(
//               height: size.height * 0.04,
//             ),
//             const TextFieldContainer(
//               childTextField: TextField(
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                     border: InputBorder.none,
//                     icon: Icon(
//                       Icons.email,
//                       color: kPrimaryColor,
//                     ),
//                     hintText: "Enter Your Email Address"),
//               ),
//             ),
//             TextFieldContainer(
//               childTextField: TextField(
//                 onChanged: (value) {},
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   icon: Icon(
//                     Icons.lock,
//                     color: kPrimaryColor,
//                   ),
//                   suffixIcon: Icon(
//                     Icons.visibility,
//                     color: kPrimaryColor,
//                   ),
//                   hintText: "Enter Your Password",
//                   hintStyle: TextStyle(),
//                 ),
//               ),
//             ),
//             RoundedButton(
//               onTap: () {},
//               title: "LOGIN",
//               buttonColor: kPrimaryColor,
//               titleColor: Colors.white,
//               paddingForRoundedButton: MaterialStateProperty.all(
//                 const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
//               ),
//             ),
//             SizedBox(
//               height: size.height * 0.025,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don't have an Account?  "),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
//                   },
//                   child: const Text("SIGNUP ", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),)),
//               ],
//             ),
//             SizedBox(
//               height: size.height * 0.025,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TextFieldContainer extends StatelessWidget {
//   final Widget childTextField;
//   const TextFieldContainer({
//     Key? key,
//     required this.childTextField,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       width: size.width * 0.8,
//       decoration: BoxDecoration(
//         color: kPrimaryLightColor,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       padding: const EdgeInsets.symmetric(
//         vertical: 5,
//         horizontal: 20,
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: childTextField,
//     );
//   }
// }
