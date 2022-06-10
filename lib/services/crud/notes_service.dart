import 'dart:async';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as devtools show log;

class NotesService {

  //  Singleton Design Pattern we'll access it through factory because it is  private instance

  // Named Constructor without body and without parameter
  NotesService._sharedInstance() {
    _notesStreamController = StreamController.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  // Creating Object
  static final NotesService _shared = NotesService._sharedInstance();
  // When someone will call NotesServices() it will return _shared which is equal to NotesService._sharedInstance()
  factory NotesService() => _shared;

  // Used this list in upon functions added notes and removed notes in list and then updated this list into streamController
  List<NotesDatabase> _notes = [];

  late final StreamController _notesStreamController;

  Stream get allNotes => _notesStreamController.stream;

  // Added it in the open function
  Future cacheNotes() async {
    try {
      final allNotes = await getAllNotes();
      _notes = allNotes!.toList();
      _notesStreamController.add(_notes);
    } on CouldNotFindNoteException {
      devtools.log("You don't have note yet.");
    }
  }

  // Step 2
  // Now using sqflite creating var then will assign value
  Database? _db;

  // Step 1
  // We'll do this Asynchronous because it has a lot of stuff it will take time like open the documents path and create tables etc.
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      devtools.log(docsPath.toString());
      final dbPath = p.join(docsPath.path, dbName);
      final openDB = await openDatabase(dbPath);
      _db = openDB;

      // await openDB.execute("drop table note");

      // Creating Tables if not exists
      await openDB.execute(createUserTable);
      await openDB.execute(createNoteTable);

      // await deleteAllNotes();
      // await _db!.delete(noteTable);

      await cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //Empty
    }
  }

  Future<void> close() async {
    if (_db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await _db?.close();
      // Reset
      _db == null;
    }
  }

  // Checking that is Database open or not
  Database? _getDatabaseOrThrow() {
    if (_db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return _db;
    }
  }

  Future<UserDatabase> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result =
        await db?.query(userTable, limit: 1, where: "email = ?", whereArgs: [
      email.toLowerCase(),
    ]);
    devtools.log(result.toString());
    if (result != null) {
      if (result.isNotEmpty) {
        throw UserAlreadyExistsException();
      }
    }
    final userId = await db!.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    devtools.log("Bravo: " + userId.toString());
    return UserDatabase(
      userId: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db?.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    // 1 is true and 0 is false
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<UserDatabase> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db?.query(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (result!.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return UserDatabase.fromRow(map: result.first);
      // return UserDatabase(userId: userId, email: email);
    }
  }

  Future<NotesDatabase> createNote({required UserDatabase owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure owner exists in database with correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }

    // create note
    const text = "";
    final noteId = await db!.insert(noteTable, {
      textColumn: text,
      userIdColumn: owner.userId,
      isSyncWithCloudColumn: 1,
    });

    final note = NotesDatabase(
      noteId: noteId,
      text: text,
      userId: owner.userId,
      isSyncWithCloud: 1,
    );

    // Adding new note
    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future deleteNote({required int noteId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db?.delete(
      noteTable,
      where: "noteId = ?",
      whereArgs: [noteId],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.noteId == noteId);
      _notesStreamController.add(_notes);
    }
  }

  Future<int?> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db?.delete(noteTable);
    if (deletedCount != 1) {
      throw CouldNotDeleteNoteException();
    }
    _notes = [];
    _notesStreamController.add(_notes);
    return deletedCount;
  }

  Future<NotesDatabase> getNote({required int noteId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db?.query(
      noteTable,
      limit: 1,
      where: "noteId = ?",
      whereArgs: [noteId],
    );
    if (result!.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      final note = NotesDatabase.fromRow(map: result.first);
      _notes.removeWhere((note) => note.noteId == noteId);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future getAllNotes() async {
    final currentUser = AuthService.firebase().currentUser!;
    final userEmail = currentUser.email;    

    devtools.log("abc" + userEmail.toString());


    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();


    final getUserInfo = await db!.query(userTable, where: "email = ?" , whereArgs: [userEmail]);
    devtools.log(getUser.toString());
    
    final getUserId =  getUserInfo[0]["userId"];
    devtools.log("def" + getUserId.toString());


    final result = await db.query(noteTable, where: "userId = ?", whereArgs: [getUserId]);

    final alpha = result.map((result) => NotesDatabase.fromRow(map: result));

    if (result != null) {
      if (result.isEmpty) {
        throw CouldNotFindNoteException();
      } else {
        //return NotesDatabase.fromRow(map: result)
        return alpha;
      }
    }    
  }

  Future<NotesDatabase> updateNote({
    required NotesDatabase note,
    required String newText,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure Note esists
    await getNote(noteId: note.noteId);

    // row to update
    Map<String, dynamic> row = {textColumn: newText, isSyncWithCloudColumn: 0};

    final updatedCount = await db?.update(
      noteTable,
      row,
      where: "noteId = ?",
      whereArgs: [note.noteId],
    );

    // final updatedCounter = await db?.update(
    //   noteTable,
    //   {
    //     textColumn: newText,
    //     isSyncWithCloudColumn: 0,
    //   },
    // );

    //SQL Query update noteTable set textColumn = newText where noteId = note.noteId

    if (updatedCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final updatedNote = await getNote(noteId: note.noteId);
      _notes.removeWhere((note) => note.noteId == updatedNote.noteId);
      _notes.add(updatedNote); // Adding in List
      _notesStreamController.add(_notes); // Updating Stream
      return updatedNote;
    }
  }

  // If user exists then we'll get otherwise we'll create user
  Future<UserDatabase> getOrCreateUser({
    required String email,
    // bool setAsCurrentUser = true,
  }) async {
    try {
      final user = await getUser(email: email);
      // if(setAsCurrentUser == true){
      //   _user = user;
      // }
      return user;
    } on CouldNotFindUserException {
      final createNewUser = await createUser(email: email);
      // if(setAsCurrentUser == true){
      //   _user = createNewUser;
      // }
      return createNewUser;
    } catch (e) {
      devtools.log(e.toString());
      rethrow;
    }
  }
} // Service Ends Here

// Database For User Starts Here
class UserDatabase {
  late final int userId;
  late final String email;

  UserDatabase({
    required this.userId,
    required this.email,
  });

  UserDatabase.fromRow({required Map<String, Object?> map}) {
    userId = map[userIdColumn] as int;
    devtools.log("UserDatabase userId is :" + userId.toString());
    email = map[emailColumn] as String;
  }

  @override
  String toString() {
    return "User ID = $userId, Email = $email";
  }

  @override
  bool operator ==(covariant UserDatabase other) => other.userId == userId;

  @override
  int get hashCode => userId.hashCode;
}

// Database For Notes Starts Here
class NotesDatabase {
  late final int noteId;
  late final String text;
  late final int userId;
  late final int isSyncWithCloud;

  NotesDatabase({
    required this.noteId,
    required this.text,
    required this.userId,
    required this.isSyncWithCloud,
  });

  NotesDatabase.fromRow({required Map<String, Object?> map}) {
    noteId = map[noteIdColumn] as int;
    text = map[textColumn] as String;
    userId = map[userIdColumn] as int;
    isSyncWithCloud = map[isSyncWithCloudColumn] as int;
  }

  @override
  String toString() {
    return "Note ID = $noteId Text = $text, User Id = $userId, Is Sync With Cloud = $isSyncWithCloud";
  }

  @override
  bool operator ==(covariant NotesDatabase other) => other.noteId == noteId;

  @override
  int get hashCode => noteId.hashCode;
}

// Constants For FromRow Constructors of User & Note
const userIdColumn = "userId";
const emailColumn = "email";
const noteIdColumn = "noteId";
const textColumn = "text";
const isSyncWithCloudColumn = "isSyncWithCloud";

// Creating More Constants for DB
const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";

// Creating User Table Using SQL
const createUserTable = """
CREATE TABLE IF NOT EXISTS "user" (
  "userId"	INTEGER NOT NULL,
  "email"	TEXT NOT NULL UNIQUE,
  PRIMARY KEY("userId" AUTOINCREMENT)
);

""";

// Creating Note Table Using SQL
const createNoteTable = """
CREATE TABLE IF NOT EXISTS "note" (
  "noteId"	INTEGER NOT NULL,
  "text"	TEXT,
  "userId"	INTEGER,
  "isSyncWithCloud"	INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY("userId") REFERENCES "user" ("userId"),
  PRIMARY KEY("noteId" AUTOINCREMENT)
);
    """;
