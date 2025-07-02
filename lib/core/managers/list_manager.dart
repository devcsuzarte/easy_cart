import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/core/models/shop_item.dart';

class ListManager {
	
	Future<List<ListItem>> fetchAll(String tableName) async {
		final db = await DatabaseService().database;
		final data = await db.query(tableName);
		
		return data.map(
			(e) => ListItem(
				id: e['id'] as int,
				amount: e['amount'] as int,
				title: e['title'] as String,
				selected: (e['selected'] as int) == 1 ? true : false
			),
		).toList();
	}

	Future<int> addItem ({
		required ListItem shopItem
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

	Future<int> toggleSelected({
		required int id,
		required bool newStatus
	}) async {
		final db = await DatabaseService().database;
		return await db.rawUpdate(
			'UPDATE $kShopListTable SET selected = ? WHERE id = ?',
  			[newStatus ? 1 : 0, id]
		);
	}

	Future<int> cleanList() async {
		final db = await DatabaseService().database;
		return await db.delete(kShopListTable);
	}
}