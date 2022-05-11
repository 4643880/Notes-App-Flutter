import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesSevice {
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
      final dbPath = p.join(docsPath.path, dbName);
      final openDB = await openDatabase(dbPath);
      _db = openDB;

      // Creating Tables if not exists
      await openDB.execute(createUserTable);
      await openDB.execute(createNoteTable);
    } catch (e) {
      throw UnableToGetDocumentDirectoryException();
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

  Database? _getDatabaseOrThrow() {
    if (_db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return _db;
    }
  }

  Future<UserDatabase> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result =
        await db?.query(userTable, limit: 1, where: "email = ?", whereArgs: [
      email.toLowerCase(),
    ]);
    if (result != null) {
      if (result.isNotEmpty) {
        throw UserAlreadyExistsException();
      }
    }
    final userId = await db!.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return UserDatabase(
      userId: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
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

    return NotesDatabase(
      noteId: noteId,
      text: text,
      userId: owner.userId,
      isSyncWithCloud: 1,
    );
  }

  Future deleteNote({required int noteId}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db?.delete(
      noteTable,
      where: "noteId = ?",
      whereArgs: [noteId],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<int?> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db?.delete(noteTable);
    if (deletedCount != 1) {
      throw CouldNotDeleteNoteException();
    }
    return deletedCount;
  }

  Future<NotesDatabase> getNote({required int noteId}) async {
    final db = _getDatabaseOrThrow();
    final result = await db?.query(
      userTable,
      limit: 1,
      where: "noteId = ?",
      whereArgs: [noteId],
    );
    if (result!.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      return NotesDatabase.fromRow(map: result.first);
    }
  }

  Future getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final result = await db?.query(noteTable);

    final alpha = result?.map((result) => NotesDatabase.fromRow(map: result));

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
    final db = _getDatabaseOrThrow();
    await getNote(noteId: note.noteId);
    final updatedCount = await db?.update(
      noteTable,
      {
        textColumn: newText,
        isSyncWithCloudColumn: 0,
      },
    );
    if (updatedCount != 1) {
      throw CouldNotUpdateNoteException();
    } else {
      return getNote(noteId: note.noteId);
    }
  }
}

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
const userIdColumn = "id";
const emailColumn = "email";
const noteIdColumn = "noteid";
const textColumn = "text";
const isSyncWithCloudColumn = "isSyncWithCloud";

// Creating More Constants for DB
const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";

// Creating User Table Using SQL
const createUserTable = """
CREATE TABLE IF NOT EXISTS "user" (
  "userId"	INTEGER,
  "email"	TEXT NOT NULL UNIQUE,
  PRIMARY KEY("userId" AUTOINCREMENT)
);

""";

// Creating Note Table Using SQL
const createNoteTable = """
CREATE TABLE IF NOT EXISTS "note" (
  "noteId"	INTEGER,
  "text"	TEXT,
  "userId"	INTEGER NOT NULL UNIQUE,
  "isSyncWithCloud"	INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY("userId") REFERENCES "user"("userId"),
  PRIMARY KEY("noteId" AUTOINCREMENT)
);
    """;
