import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'dart:developer' as devtools show log;

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  NotesDatabase? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  Future createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null && _textController.text == "  ") {
      _notesService.deleteNote(noteId: note.noteId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final newText = _textController.text;
    if (_textController.text != "  " &&_textController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        note: note,
        newText: newText,
      );
    }
  }

  // As we type in textfield it will update in database
  void _textControllerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final newText = _textController.text;
    await _notesService.updateNote(
      note: note,
      newText: newText,
    );
  }

  void _setupTextControllerListner() async {
    _textController.removeListener(_textControllerListner);
    _textController.addListener(_textControllerListner);
  }


  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done: 
              _note = snapshot.data as NotesDatabase;
              _setupTextControllerListner();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Start Typing Here"),
                );
            default:
              return const Center(child: CircularProgressIndicator(),);

          }

      },),
    );
  }
}
