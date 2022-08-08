import 'package:flutter/material.dart';
import 'package:mynotes/constants/constants.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialog/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
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
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        final getNote = notes.elementAt(index);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: kPrimaryLightColor,
              child: ListTile(
                onTap: () {
                  onTap(getNote);
                },
                title: Text(
                  getNote.text,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
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
                    icon: const Icon(
                      Icons.delete,
                      color: kPrimaryColor,
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}
