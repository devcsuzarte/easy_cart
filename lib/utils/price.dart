import 'package:easy_cart/data/models/product.dart';

class PriceUtils {
	
	static String getTotalPrice(List<Product> products){
		double total = 0;

		for(var product in products){
			if(product.price != null && product.amount != null){
				total = total + (double.parse(product.price!) * product.amount!);
			}
		}
		return total.toStringAsFixed(2);
	}
}