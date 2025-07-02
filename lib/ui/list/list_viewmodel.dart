import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/managers/list_manager.dart';
import 'package:easy_cart/core/models/shop_item.dart';
import 'package:stacked/stacked.dart';

class ListViewModel extends FutureViewModel{

	late ListManager listManager;

	ListViewModel({
		required this.listManager
	});

	ReactiveValue<List<ListItem>> shopList = ReactiveValue(List.empty());

	@override
	Future futureToRun() async {
		await getList();
	}

	Future<void> getList() async {
		shopList.value = await listManager.fetchAll(kShopListTable);
		notifyListeners();
	}

	Future<void> addItem({
		required String title,
		required int amount
	}) async {
		ListItem newItem = ListItem(
			title: title, 
			amount: amount
		);
		listManager.addItem(shopItem: newItem);
		await getList();
	}

	void deleteItem(int itemId) async {
		listManager.deleteItem(
			id: itemId
		);
		await getList();
	}
	
	void toggleSelected({
		required int id, 
		required bool newStatus
	}) async {
		listManager.toggleSelected(id: id, newStatus: newStatus);
		notifyListeners();
		await getList();
	}

	void cleanList() async {
		listManager.cleanList();
		await getList();
	}
}