import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/models/history.dart';
import 'package:easy_cart/utils/scanner.dart';
import 'package:easy_cart/core/models/product.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';


class CartViewModel extends FutureViewModel{

	late Scanner scanManager;
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
		productsList.value = await productManager.fetchProducts(kProductTable);
		total.value = PriceUtils.getTotalPrice(productsList.value);
		notifyListeners();
	}

	void deleteProduct(int productID) async {
		productManager.deleteProduct(
			id: productID
		);
		await getData();
	}

	void cleanCartList() async {
		Cart cart = Cart(
			date: DateTime.now().millisecondsSinceEpoch.toString(),
			totalItems: productsList.value.length, 
			total: total.value
		);

		await productManager.saveCart(cart: cart).whenComplete(
			(){
				productManager.cleanCart();
			}
		);
		
		await getData();
	}
}