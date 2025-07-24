import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:easy_cart/utils/scanner.dart';
import 'package:easy_cart/core/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ScanViewmodel extends FutureViewModel {

	late ProductManager productManager;
	final imagePicker = ImagePicker();
	final bool isEditing;
	final Product? product;

	ReactiveValue<String> label = ReactiveValue(''), 
		price = ReactiveValue('0,00'),
		total = ReactiveValue('0,00'); 
	ReactiveValue<List<String>> labelsList = ReactiveValue(List.empty()), 
		pricesList = ReactiveValue(List.empty());
	ReactiveValue<int> labelSelected = ReactiveValue(0), 
		priceSelected = ReactiveValue(0),
		amount = ReactiveValue(1);

	ScanViewmodel({
		required this.productManager,
		required this.isEditing,
		this.product
	});

	@override
	Future futureToRun() async {
		if(isEditing && product != null) {
			label.value = product!.title;
			price.value = product!.price;
			amount.value = product!.amount;
			total.value = PriceUtils.getPriceTotal(product!.price, product!.amount);
			notifyListeners();
		} else {
			await scanLabel();
		}
	}

	Future<void> scanLabel() async {
		final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
		final Scanner scanner = Scanner();
		try {
			await scanner.processScan(pickedFile!);

			labelsList.value = scanner.getLabels();
			pricesList.value = scanner.getPrices();

			setLabel();
			setPrice();
		
		} catch (e) {
			throw('SOMETHING WENT WRONG: $e');
		}
	}

	Future<void> addItem({
		required String title,
		required String price
	}) async {
		Product newProduct = Product(
			amount: amount.value, 
			price: price, 
			title: title
		);
		try {
			runBusyFuture(
				productManager.addProduct(product: newProduct)
			);
		} catch (e){
			throw Exception('Not able to add product: $e');
		}
	}

	Future<void> updateProduct(String title, String price, int amount) async {
		Product updatedProduct = Product(
			amount: amount, 
			price: price, 
			title: title
		);

		productManager.updateItem(id: product!.id!, product: updatedProduct);
	}

	void setLabel(){
		label.value = labelsList.value.isNotEmpty ? labelsList.value.first : '';
		notifyListeners();
	}

	void setPrice(){
		price.value = pricesList.value.isNotEmpty ? pricesList.value.first : '0,00';
		updateTotalPrice(price.value);
		notifyListeners();
	}

	void onPriceChanged(String newPrice) {
		price.value = newPrice;
		total.value = PriceUtils.getPriceTotal(price.value, amount.value);
		notifyListeners();
	}

	void updateTotalPrice(String newPrice) {
		total.value = PriceUtils.getPriceTotal(price.value, amount.value);
		notifyListeners();
	}

	void refreshLabel() {
		labelsList.value.shuffle();
		setLabel();
	} 
		
	void refreshPrice() { 
		pricesList.value.shuffle();
		setPrice();
	}

	void increaseAmount(){
		amount.value++;
		updateTotalPrice(PriceUtils.getPriceTotal(price.value, amount.value));
		notifyListeners();
	}

	void decreaseAmount(){
		if (amount.value > 1) {
			amount.value--;
			updateTotalPrice(PriceUtils.getPriceTotal(price.value, amount.value));
			notifyListeners();
		}
	}
}