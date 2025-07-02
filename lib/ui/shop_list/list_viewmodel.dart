import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database/shop_list_manager.dart';
import 'package:easy_cart/data/models/shop_item.dart';
import 'package:stacked/stacked.dart';

class ListViewModel extends FutureViewModel{

	late ShopListManager shopListManager;

	ListViewModel({
		required this.shopListManager
	});

	ReactiveValue<List<ShopItem>> shopList = ReactiveValue(List.empty());

	@override
	Future futureToRun() async {
		await getList();
	}

	Future<void> getList() async {
		shopList.value = await shopListManager.fetchAll(kShopListTable);
		notifyListeners();
	}

	Future<void> addItem({
		required String title,
		required int amount
	}) async {
		ShopItem newItem = ShopItem(
			title: title, 
			amount: amount
		);
		shopListManager.addItem(shopItem: newItem);
		await getList();
	}

	void deleteItem(int itemId) async {
		shopListManager.deleteItem(
			id: itemId
		);
		await getList();
	}
	
	void toggleSelected({
		required int id, 
		required bool newStatus
	}) async {
		shopListManager.toggleSelected(id: id, newStatus: newStatus);
		notifyListeners();
		await getList();
	}

	void cleanList() async {
		shopListManager.cleanList();
		await getList();
	}
}