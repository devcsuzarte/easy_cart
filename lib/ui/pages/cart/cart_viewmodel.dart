import 'package:easy_cart/core/scan_manager.dart';
import 'package:easy_cart/data/models/product.dart';
import 'package:easy_cart/utils/price.dart';

import 'package:easy_cart/core/database_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';


class CartViewModel extends FutureViewModel{

	late DatabaseManager databaseManager;
	late ScanManager scanManager;
	final imagePicker = ImagePicker();

	ReactiveValue<List<Product>> productsList = ReactiveValue(List.empty());
	ReactiveValue<double> total = ReactiveValue(0.0);
	

	CartViewModel({
		required this.databaseManager
	});

	@override
	 Future futureToRun() async {
		await getData();

	}

	Future<void> addProduct(Product product) async {
		productsList.value.add(product);
		var price = product.price!.replaceAll(',', '.');

		runBusyFuture(databaseManager.create(
			title: product.title!, 
			price: double.parse(price), 
			amount: product.amount!
			)
		);
		
		await getData();
	}

	Future<void> getData() async {
		productsList.value = await databaseManager.fetchAll;
		setTotalCartPrice();
		notifyListeners();
	}

	void deleteProduct(int productID) async {
		databaseManager.delete(productID);
		await getData();
	}

	void cleanCartList() async {
		databaseManager.deleteTable();
		await getData();
	}

	void setTotalCartPrice() {
		total.value = PriceUtils.getTotalPrice(productsList.value);
		notifyListeners();
	}
}