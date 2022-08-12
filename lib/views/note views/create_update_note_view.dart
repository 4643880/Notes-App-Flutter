import 'package:flutter/material.dart';
import 'package:mynotes/constants/constants.dart';
import 'package:mynotes/extensions/buildcontext/my_localization.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialog/cannot_share_empty_note_dialog.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  Future createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    devtools.log(widgetNote.toString());

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final ownerUserId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: ownerUserId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final newText = _textController.text;
    if (_textController.text != "  " &&
        _textController.text.isNotEmpty &&
        note != null) {
      await _notesService.updateNote(
          documentId: note.documentId, text: newText);
    }
  }

  // As we type in textfield it will update in database
  void _textControllerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final newText = _textController.text;
    await _notesService.updateNote(documentId: note.documentId, text: newText);
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
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(context.myloc.new_note_page_title),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCanNotShareEmptyNoteDialog(
                    context,
                    context.myloc
                        .new_note_page_showCanNotShareEmptyNoteDialog_title,
                    context.myloc
                        .new_note_page_showCanNotShareEmptyNoteDialog_desc);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListner();
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.8,
                    color: kPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: context.myloc.new_note_page_text_field_label,
                          hintStyle: const TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
