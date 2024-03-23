import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//note
class Note {
  final int? id;
  final String title;
  final String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}

//todo
class TODO {
  final int? id;
  final String title;
  final int? value;

  TODO({
    this.id,
    required this.title,
    this.value = 0,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
    };
  }
}

//sql
class SqlHelper {
  Database? database;
//get db
  getDatabase() async {
    if (database != null) return database;
    database = await initDatabase();
    return database;
  }

//create db
  initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db'); //data base path
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        Batch batch = db.batch();
        batch.execute('''
          CREATE TABLE notes(
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             title TEXT,
             content TEXT 
          )
        ''');
        batch.execute('''
          CREATE TABLE todo(
             id INTEGER PRIMARY KEY,
             title TEXT,
             value INTEGER
          )
        ''');
        batch.commit();
      },
    );
  }

//insert notes
  Future insertNote(Note note) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    batch.commit();
  }

//insert todo
  Future insertToDo(TODO todo) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    batch.commit();
  }

//read notes
  Future<List<Map>> loadNotes() async {
    Database db = await getDatabase();
    List<Map> maps = await db.query('notes');
    return List.generate(maps.length, (index) {
      return Note(
        id: maps[index]['id'],
        title: maps[index]['title'],
        content: maps[index]['content'],
      ).toMap();
    });
  }

  //read todo
  Future<List<Map>> loadToDo() async {
    Database db = await getDatabase();
    List<Map> maps = await db.query('todo');
    return List.generate(maps.length, (index) {
      return TODO(
        id: maps[index]['id'],
        title: maps[index]['title'],
        value: maps[index]['value'],
      ).toMap();
    });
  }

//update notes
  Future updateNote(Note newnote) async {
    Database db = await getDatabase();
    await db.update(
      'notes',
      newnote.toMap(),
      where: 'id=?',
      whereArgs: [newnote.id],
    );
  }

//update todo
  Future updateTodo(TODO newtodo) async {
    Database db = await getDatabase();
    await db.update(
      'todo',
      newtodo.toMap(),
      where: 'id=?',
      whereArgs: [newtodo.id],
    );
  }

  Future updateToDoChecked(int id, int CurrentValue) async {
    Database db = await getDatabase();
    Map<String, dynamic> values = {
      'value': CurrentValue == 0 ? 1 : 0,
    };
    await db.update(
      'todo',
      values,
      where: 'id=?',
      whereArgs: [id],
    );
  }

//delete all notes
  Future deleteAllNotes() async {
    Database db = await getDatabase();
    await db.delete('notes');
  }

//delete all todo
  Future deleteAllToDo() async {
    Database db = await getDatabase();
    await db.delete('todo');
  }

//delete note
  Future deleteNote(int id) async {
    Database db = await getDatabase();

    await db.delete(
      'notes',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
