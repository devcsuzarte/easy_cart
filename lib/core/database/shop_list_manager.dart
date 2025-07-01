import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/data/models/shop_item.dart';

class ShopListManager {
	
	Future<List<ShopItem>> fetchAll(String tableName) async {
		final db = await DatabaseService().database;
		final data = await db.query(tableName);
		
		return data.map(
			(e) => ShopItem(
				id: e['id'] as int,
				amount: e['amount'] as int,
				title: e['title'] as String,
				selected: (e['selected'] as int) == 1 ? true : false
			),
		).toList();
	}

	Future<int> addItem ({
		required ShopItem shopItem
	}) async {
		final db = await DatabaseService().database;
		return await db.rawInsert(
			'''INSERT INTO $kShopListTable (title, selected, amount) VALUES (?,?,?)''',
			[
				shopItem.title, 
				shopItem.selected ? 1 : 0,
				shopItem.amount
			]
		);
	}
	
	Future<int> deleteItem ({
		required int id
	}) async {
		return DatabaseManager().delete(id: id, tableName: kShopListTable);
	}

	Future<int> cleanList() async {
		final db = await DatabaseService().database;
		return await db.delete(kShopListTable);
	}
}