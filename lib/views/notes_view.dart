
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


enum MenuActions { logout }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<MenuActions>(
            onSelected: (value)async {
              switch (value){                
                case MenuActions.logout:
                 final gettingLogOutValue = await showLogOutDialogFunc(context);
                 if(gettingLogOutValue== true){
                   await FirebaseAuth.instance.signOut();
                   Navigator.of(context).pushNamedAndRemoveUntil("/login/", (route) => false);
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
          ),
        ],
      ),
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