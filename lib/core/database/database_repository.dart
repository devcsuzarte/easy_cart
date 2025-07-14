import 'package:easy_cart/core/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
	Future<void> createTable(Database database) async {
		await database.execute("""
		CREATE TABLE IF NOT EXISTS $kProductTable (
		id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
		title TEXT NOT NULL,
		price TEXT NOT NULL,
		amount INTEGER NOT NULL
		)
		""");

		await database.execute("""
		CREATE TABLE IF NOT EXISTS $kShopListTable (
		id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
		title TEXT NOT NULL,
		selected INTEGER NOT NULL,
		amount INTEGER NOT NULL
		)
		""");

		await database.execute("""
		CREATE TABLE IF NOT EXISTS $kCartHistoryTable (
		id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
		date TEXT NOT NULL,
		total TEXT NOT NULL,
		totalItems INTEGER NOT NULL
		)
		""");
	}

	Future<int> delete ({
		required int id, 
		required String tableName
	}) async {
		final db = await DatabaseService().database;
		return await db.delete(
			tableName,
			where: 'id = ?',
			whereArgs: [id],
		);
	}

	Future<int> deleteTable(String tableName) async {
		final db = await DatabaseService().database;
		return await db.delete(tableName);
	}
  
}

class DatabaseService {

  Database? _database;

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'easy_cart.db';
    final path = await getDatabasesPath();
    return (join(path, name));
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );

    return database;
  }

  Future<void> create(Database database, int version) async => await DatabaseManager().createTable(database);
}