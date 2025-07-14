import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/models/history.dart';
import 'package:stacked/stacked.dart';

class HistoryViewmodel  extends FutureViewModel{

	late ProductManager productManager;

	ReactiveValue<List<Cart>> history = ReactiveValue(List.empty());

	HistoryViewmodel({
		required this.productManager
	});

	@override
	Future futureToRun() async {
		await _getHistory();
	}

	Future<void> _getHistory() async {
		history.value = await productManager.fetchHistory();
		notifyListeners();
	}
}