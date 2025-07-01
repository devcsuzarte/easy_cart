import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database/product_manager.dart';
import 'package:easy_cart/core/scan_manager.dart';
import 'package:easy_cart/data/models/product.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';


class CartViewModel extends FutureViewModel{

	late ScanManager scanManager;
	late ProductManager productManager;
	final imagePicker = ImagePicker();

	ReactiveValue<List<Product>> productsList = ReactiveValue(List.empty());
	ReactiveValue<String> total = ReactiveValue('0.0');
	
	CartViewModel({
		required this.productManager
	});

	@override
	 Future futureToRun() async {
		await getData();
	}


	Future<void> getData() async {
		productsList.value = await productManager.fetchAll(kProductTable);
		setTotalCartPrice();
		notifyListeners();
	}

	void deleteProduct(int productID) async {
		productManager.deleteProduct(
			id: productID
		);
		await getData();
	}

	void cleanCartList() async {
		productManager.cleanCart();
		await getData();
	}

	void setTotalCartPrice() {
		total.value = PriceUtils.getTotalPrice(productsList.value);
		notifyListeners();
	}
}