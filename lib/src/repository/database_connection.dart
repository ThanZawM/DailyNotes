import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    //var path = join(await getDatabasesPath(), 'db_dailynotes');
    var path = join(directory.path, 'db_dailynotes');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return database;
  }

  _onCreateDatabase(Database database, int version) async {
    //create table categories
    await database.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    //create table notes
    await database.execute(
        "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT, date TEXT, category TEXT, isFinished INTEGER)");
  }
}

//FOREIGN KEY (categoryId) REFERENCES categories(id)
