import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_cart/core/models/product.dart';

class PriceUtils {
	
	static String getTotalCartPrice(List<Product> products) {
		double total = 0;

		for(var product in products){
			total = total + (formatedToDouble(product.price) * product.amount);
		}
		return total.toStringAsFixed(2);
	}

	static double convertPrice(String price) {
		String priceWithouMask = price.replaceRange(0, 3, '');
		String priceConverted = priceWithouMask.replaceAll(',', '.');
		
		return double.tryParse(priceConverted) ?? 0.00;
		
	}

	static String getDisplayPrice(String value) {
		return defaultFormat.formatString(value);
	}

	static String getPriceTotal(String value, int amount) {
		double price = formatedToDouble(value);
		
		return (price * amount).toStringAsFixed(2);
	}

	static double formatedToDouble(String value) {
		String cleanedValue = removeCurrency(value);
		return double.tryParse(cleanedValue) ?? 0.0;
	}

	static String removeCurrency(String value) {
		String cleanedValue = value.
			replaceAll(RegExp(r'[^0-9.,]'), '')
			.replaceFirst(',', '.')
			.replaceAll(',', '');
		return cleanedValue;
	}

	static CurrencyTextInputFormatter defaultFormat = CurrencyTextInputFormatter.currency(
		locale: 'pt-br',
		decimalDigits: 2,
		symbol: 'R\$',
		inputDirection: InputDirection.left
	);
}