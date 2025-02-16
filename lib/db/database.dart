import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "products.db";
  static final _databaseVersion = 1;

  static final table = 'product';

  static final columnId = 'pId';
  static final columnName = 'pName';
  static final columnQte = 'pQte';
  static final columnSPrice = 'pSelPrice';
  static final columnBPrice = 'pBuyPrice';
  static final columnExp = 'pExp';
  static final columnBarCode = 'pCode';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnQte INTEGER NOT NULL,
            $columnSPrice REAL NOT NULL,
            $columnBPrice REAL NOT NULL,
            $columnExp DATE,
            $columnBarCode TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> serchProduct(String value) async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE pName LIKE '%$value%' OR pCode = '$value'");
  }

  Future<List<Map<String, dynamic>>> serchProductByQrCode(String code) async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE pCode = $code");
  }

  Future<List<Map<String, dynamic>>> redCardProducts(int val) async {
    Database db = await instance.database;
    if(val == 1)
      return await db.rawQuery("SELECT * FROM $table WHERE pQte <= 5 OR pExp < DATE() ORDER BY pQte");
    else
      return await db.rawQuery("SELECT * FROM $table WHERE pQte <= 5 OR pExp < DATE() ORDER BY pExp");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}