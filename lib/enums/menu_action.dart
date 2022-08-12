import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/extensions/buildcontext/my_localization.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_events.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialog/logout_dialog.dart';

enum MenuActions { logout }

class MyMenuActionButton extends StatefulWidget {
  const MyMenuActionButton({Key? key}) : super(key: key);

  @override
  State<MyMenuActionButton> createState() => _MenuActionButtonState();
}

class _MenuActionButtonState extends State<MyMenuActionButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuActions>(
      onSelected: (value) async {
        switch (value) {
          case MenuActions.logout:
            // title: const Text("Sign Out"),
            // content: const Text("Are you sure you would like to log out?"),
            final gettingLogOutValue = await showLogOutDialogFunc(
              context,
              context.myloc.showLogOutDialogFunc_title,
              context.myloc.showLogOutDialogFunc_desc,
            );

            if (gettingLogOutValue == true) {
              BlocProvider.of<AuthBloc>(context).add(const AuthEventLogOut());
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
