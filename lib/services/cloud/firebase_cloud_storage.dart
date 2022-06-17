import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // Singleton Pattern
  FirebaseCloudStorage.sharedInstance();

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage.sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  final notes = FirebaseFirestore.instance.collection('notes');

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
    });
  }

  Future getNote({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream allNotes({required String ownerUserId}) {
    final notes = FirebaseFirestore.instance.collection('notes');
    return notes.snapshots().map(
          (event) => event.docs
              .map(
                (doc) => CloudNote.fromSnapshot(doc),
              )
              .where((note) => note.ownerUserId == ownerUserId),
        );
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName : text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try{
      notes.doc(documentId).delete();

    } catch(e){
      throw CouldNotDeleteNoteException();
    }
  }
}// Class Ends Here
