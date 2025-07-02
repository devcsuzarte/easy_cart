import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/core/models/product.dart';

class ProductManager {
	
	Future<List<Product>> fetchAll(String tableName) async {
		final db = await DatabaseService().database;
		final data = await db.query(tableName);
		
		return data.map(
			(e) => Product(
				id: e['id'] as int,
				amount: e['amount'] as int,
				price: e['price'] as String,
				title: e['title'] as String
			),
		).toList();
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

	Future<int> cleanCart() async {
		final db = await DatabaseService().database;
		return await db.delete(kProductTable);
	}
}