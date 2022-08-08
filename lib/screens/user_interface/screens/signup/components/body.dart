// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mynotes/screens/user_interface/components/rounded_button.dart';
// import 'package:mynotes/constants/constants.dart';
// import 'package:mynotes/screens/user_interface/screens/signup/components/background.dart';

// class SignUpBody extends StatelessWidget {
//   const SignUpBody({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SignUpBackground(
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: size.height * 0.025,
//             ),
//             const Text(
//               "SIGNUP",
//               style: TextStyle(
//                 color: kPrimaryColor,
//                 fontSize: 25,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             SizedBox(
//               height: size.height * 0.04,
//             ),
//             SvgPicture.asset("assets/icons/signup.svg",height: size.height * 0.35),
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
//               title: "SIGNUP",
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
//                 const Text("Already have an Account?  "),
//                 InkWell(
//                     onTap: () {
//                       // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
//                     },
//                     child: const Text(
//                       "LOGIN ",
//                       style: TextStyle(
//                           color: kPrimaryColor, fontWeight: FontWeight.bold),
//                     )),
//               ],
//             ),
//             SizedBox(
//               height: size.height * 0.025,
//             ),
//             const OrDivider(),            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: kPrimaryLightColor),
//                       shape: BoxShape.circle,
//                     ),                
//                     padding: const EdgeInsets.all(20),
//                     child: SvgPicture.asset("assets/icons/facebook.svg", color: kPrimaryColor, height: size.height * 0.03,),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: kPrimaryLightColor),
//                       shape: BoxShape.circle,
//                     ),                
//                     padding: const EdgeInsets.all(20),
//                     child: SvgPicture.asset("assets/icons/twitter.svg", color: kPrimaryColor, height: size.height * 0.03,),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: kPrimaryLightColor),
//                       shape: BoxShape.circle,
//                     ),                
//                     padding: const EdgeInsets.all(20),
//                     child: SvgPicture.asset("assets/icons/google-plus.svg", color: kPrimaryColor, height: size.height * 0.03,),
//                   ),
//                 ),
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



// class OrDivider extends StatelessWidget {
//   const OrDivider({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       width: size.width * 0.8,
//       child: Row(
//         children: const [
//           Expanded(
//             child: Divider(
//               color: Color(0xffd9d9d9),
//               thickness: 2,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               "OR",
//               style: TextStyle(fontWeight: FontWeight.w900, color: kPrimaryColor),
//             ),
//           ),
//           Expanded(
//             child: Divider(
//               color: Color(0xffd9d9d9),
//               thickness: 2,
//             ),
//           ),
//         ],
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
