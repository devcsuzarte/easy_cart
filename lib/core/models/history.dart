import 'package:easy_cart/core/models/product.dart';

class History {
	final String date,
		total;
	final List<Product> products;

	History({
		required this.date,
		required this.total,
		required this.products
	});

}