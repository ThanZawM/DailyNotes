import 'package:DailyNotes/src/repository/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _databaseConntection;

  Repository() {
    _databaseConntection = DatabaseConnection();
  }

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConntection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return await connection
        .query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, itemId) async {
    var connection = await database;
    return await connection.delete(table, where: 'id=?', whereArgs: [itemId]);
  }
}
