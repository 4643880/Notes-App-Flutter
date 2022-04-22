import 'package:flutter/material.dart';
import 'package:mynotes/enums/menu_action.dart';




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
        actions: const [
          MyMenuActionButton(),
        ],
      ),
    );
  }
}

