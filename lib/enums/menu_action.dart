import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';


enum MenuActions { logout }

class MyMenuActionButton extends StatefulWidget {
  const MyMenuActionButton({ Key? key }) : super(key: key);

  @override
  State<MyMenuActionButton> createState() => _MenuActionButtonState();
}

class _MenuActionButtonState extends State<MyMenuActionButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuActions>(
            onSelected: (value)async {
              switch (value){                
                case MenuActions.logout:
                 final gettingLogOutValue = await showLogOutDialogFunc(context);
                 if(gettingLogOutValue== true){
                   await AuthService.firebase().logOut();
                   Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                 }
                 devtools.log(gettingLogOutValue.toString());
                break;
              }
              devtools.log(value.toString());
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<MenuActions>(
                  value: MenuActions.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          );
  }
}


Future<bool> showLogOutDialogFunc(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you would like to log out?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out")),
          ],
        );
      }).then((value) => value ?? false);
}