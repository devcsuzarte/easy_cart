import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/utils/scanner.dart';
import 'package:easy_cart/core/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ScanViewmodel extends FutureViewModel {

	late ProductManager productManager;
	final imagePicker = ImagePicker();

	ReactiveValue<String> label = ReactiveValue(''), 
		price = ReactiveValue('0,00'); 
	ReactiveValue<List<String>> labelsList = ReactiveValue(List.empty()), 
		pricesList = ReactiveValue(List.empty());
	ReactiveValue<int> labelSelected = ReactiveValue(0), 
		priceSelected = ReactiveValue(0),
		amount = ReactiveValue(1);

	ScanViewmodel({
		required this.productManager
	});

	@override
	Future futureToRun() async {
		await scanLabel();
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

	void setLabel(){
		label.value = labelsList.value.isNotEmpty ? labelsList.value.first : '';
		notifyListeners();
	}

	void setPrice(){
		price.value = pricesList.value.isNotEmpty ? pricesList.value.first : '0,00';
		notifyListeners();
	}

	void updatePriceFromView(String newPrice){
		price.value = newPrice;
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
		notifyListeners();
	}

	void decreaseAmount(){
		if(amount.value > 1){
			amount.value--;
		}
		notifyListeners();
	}
}