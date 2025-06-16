import 'package:easy_cart/core/scan_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ScanViewmodel extends FutureViewModel {

	late ScanManager scanManager;
	final imagePicker = ImagePicker();

	ReactiveValue<String> label = ReactiveValue(''); 
	ReactiveValue<String> price = ReactiveValue('0,00'); 
	ReactiveValue<List<String>> labelsList = ReactiveValue(List.empty());
	ReactiveValue<List<String>> pricesList = ReactiveValue(List.empty());

	ScanViewmodel({
		required this.scanManager
	});

	@override
	Future futureToRun() async {
		await scanLabel();
	}

	Future<void> scanLabel() async {
		final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
		try {
			await scanManager.processScan(pickedFile!);

			labelsList.value = scanManager.getLabels();
			pricesList.value = scanManager.getPrices();
		
			label.value = labelsList.value.isNotEmpty ? labelsList.value.first : '';
			price.value = pricesList.value.isNotEmpty ? pricesList.value.first : '0,00';

			notifyListeners();
		} catch (e) {
			throw('SOMETHING WENT WRONG: $e');
		}
	}
}