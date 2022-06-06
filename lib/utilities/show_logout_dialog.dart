
// import 'package:flutter/material.dart';

// Future<bool> showLogOutDialogFunc(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Sign Out"),
//           content: const Text("Are you sure you would like to log out?"),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Text("Cancel")),
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: const Text("Log out")),
//           ],
//         );
//       }).then((value) => value ?? false);
// }