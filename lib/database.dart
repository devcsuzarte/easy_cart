import 'package:sqflite/sqflite.dart';
import 'models/product.dart';
import 'package:path/path.dart';

class EZCartDB {
  final tableName = 'products';

  Future<void> createTable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    lableTitle TEXT NOT NULL,
    lablePrice TEXT NOT NULL,
    amount INTEGER NOT NULL
    )
    """);
  }

  Future<List<Product>> get fetchAll async {
    final db = await DatabaseService().database;
    final data = await db.query(tableName);
    List<Product> products = data.map(
          (e) => Product(
        id: e['id'] as int?,
        amount:   e['amount'] as int?,
        labelPrice:   e['lablePrice'] as String?,
        labelTitle:   e['lableTitle'] as String?
      ),
    ).toList();
    print("from DB: ${data}");
    return products;
  }

  Future<int> create({required String title, required double price, required int amount}) async {
    final db = await DatabaseService().database;
    return await db.rawInsert(
      '''INSERT INTO $tableName (lableTitle, lablePrice, amount) VALUES (?,?,?)''',
      [title, price, amount]
    );
  }

  Future<int> delete({required int id}) async {
    final db = await DatabaseService().database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [
        id
      ],
    );
  }

  Future<int> deleteTable() async {
    final db = await DatabaseService().database;
    return await db.delete(
      tableName
    );
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

  Future<void> create(Database database, int version) async => await EZCartDB().createTable(database);
}