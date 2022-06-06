import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialog/delete_dialog.dart';

typedef NoteCallBack = void Function(NotesDatabase note);

class NotesListView extends StatelessWidget {
  final List<NotesDatabase> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        final getNote = notes[index];
        return ListTile(
          onTap: () {
            onTap(getNote);
          },
          title: Text(
            getNote.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(
                  context,
                  "Delete",
                  "Are you sure you want to delete this note?",
                );
                if (shouldDelete == true) {
                  onDeleteNote(getNote);
                }
              },
              icon: const Icon(Icons.delete)),
        );
      },
    );
  }
}