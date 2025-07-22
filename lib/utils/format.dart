import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class FormatUtils {
	static String getDisplayPrice(String value) {
		return defaultFormat.formatString(value);
	}

	static String getPriceTotal(String value, int amount) {
		double price = double.tryParse(value) ?? 0;
		return (price * amount).toString();
	}

	static double formatedToDouble(String value, int amount) {
		double price = double.tryParse(value) ?? 0;
		return 0.0;
	}

	static CurrencyTextInputFormatter defaultFormat = CurrencyTextInputFormatter.currency(
		locale: 'pt-br',
		decimalDigits: 2,
		symbol: 'R\$',
		inputDirection: InputDirection.left
	);
}