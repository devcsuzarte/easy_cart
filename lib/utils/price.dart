import 'package:easy_cart/data/models/product.dart';

class PriceUtils {
	
	static String getTotalPrice(List<Product> products){
		double total = 0;

		for(var product in products){
			total = total + (convertPrice(product.price) * product.amount);
		}
		return total.toStringAsFixed(2);
	}

	static double convertPrice(String price){
		String priceWithouMask = price.replaceRange(0, 3, '');
		String priceConverted = priceWithouMask.replaceAll(',', '.');
		
		return double.tryParse(priceConverted) ?? 0.00;
		
	}
}