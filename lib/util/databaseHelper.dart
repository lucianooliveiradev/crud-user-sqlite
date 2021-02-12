import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:cruduser/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDownGrade);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, login TEXT, password TEXT, isDeleted BOOLEAN)");

    print("_onCreate");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 || newVersion == 2) {
      await db.execute("DROP TABLE User");
      await db.execute(
          "CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, login TEXT, password TEXT, isDeleted BOOLEAN)");
    }

    print(
        "Old Version: ${oldVersion.toString()} / New Version: ${newVersion.toString()}");
  }

  _onDownGrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion > 8 || newVersion <= 8) {}
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toJson());
    return res;
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> employees = new List();

    if (list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        var user = new User(
            id: list[i]["id"],
            name: list[i]["name"],
            login: list[i]["login"],
            password: list[i]["password"],
            isDeleted: list[i]["isDeleted"] == 0 ? false : true);

        employees.add(user);
      }
    }

    print(employees.length);
    return employees;
  }

  Future<int> deleteUsers(User user) async {
    var dbClient = await db;

    int res =
        await dbClient.rawDelete('DELETE FROM User WHERE id = ?', [user.id]);
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;
    int res = await dbClient.update("User", user.toJson(),
        where: "id = ?", whereArgs: <int>[user.id]);
    return res > 0 ? true : false;
  }
}
