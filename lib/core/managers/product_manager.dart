import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/core/models/history.dart';
import 'package:easy_cart/core/models/product.dart';

class ProductManager {
	
	Future<List<Product>> fetchProducts(String tableName) async {
		final db = await DatabaseService().database;
		final data = await db.query(tableName);
		
		if (data.isNotEmpty) {
			return data.map(
				(e) => Product(
					id: e['id'] as int,
					amount: e['amount'] as int,
					price: e['price'] as String,
					title: e['title'] as String
				),
			).toList();
		}
		return List.empty();
	}

	Future<int> addProduct ({
		required Product product
	}) async {
		final db = await DatabaseService().database;
		return await db.rawInsert(
			'''INSERT INTO $kProductTable (title, price, amount) VALUES (?,?,?)''',
			[product.title, product.price, product.amount]
		);
	}

	Future<int> deleteProduct ({
		required int id
	}) async {
		return DatabaseManager().delete(id: id, tableName: kProductTable);
	}
	
	Future<int> saveCart ({
		required Cart cart
	}) async {
		final db = await DatabaseService().database;
		return await db.rawInsert(
			'''INSERT INTO $kCartHistoryTable (date, totalItems, total) VALUES (?,?,?)''',
			[cart.date, cart.totalItems, cart.total]
		);
	}

	Future<List<Cart>> fetchHistory() async {
		final db = await DatabaseService().database;
		final data = await db.query(kCartHistoryTable);

		if (data.isNotEmpty) {
			return data.map(
				(e) => Cart(
					id: e['id'] as int,
					totalItems: e['totalItems'] as int,
					date: e['date'] as String,
					total: e['total'] as String
				),
			).toList();
		}
		return List.empty();	
	}

	Future<int> updateItem({
		required int id,
		required Product product
	}) async {
		final db = await DatabaseService().database;
		return await db.rawUpdate(
			'UPDATE $kProductTable SET amount = ?, price = ?, title = ? WHERE id = ?',
  			[product.amount, product.price, product.title, id]
		);
	}

	Future<int> cleanCart() async {
		final db = await DatabaseService().database;
		return await db.delete(kProductTable);
	}
}