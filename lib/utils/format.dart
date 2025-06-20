import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class FormatUtils {
	static String getDisplayPrice(String value) {
		return defaultFormat.formatString(value);
	}

	static CurrencyTextInputFormatter defaultFormat = CurrencyTextInputFormatter.currency(
		locale: 'pt-br',
		decimalDigits: 2,
		symbol: 'R\$',
		inputDirection: InputDirection.left
	);
}