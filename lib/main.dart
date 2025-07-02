import 'package:easy_cart/core/database/product_manager.dart';
import 'package:easy_cart/core/database/shop_list_manager.dart';
import 'package:easy_cart/ui/cart/cart_page.dart';
import 'package:easy_cart/ui/shop_list/list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/core/scan_manager.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				Provider(
					create: (context) => DatabaseManager()
				),
				Provider(
					create: (context) => ScanManager()
				),
				Provider(
					create: (context) => ProductManager()
				),
				Provider(
					create: (context) => ListManager()
				)
			],
			child: MaterialApp(
				initialRoute: '/',
				routes: {
					// When navigating to the "/" route, build the FirstScreen widget.
					'/': (context) => const CartPage(),
					// When navigating to the "/second" route, build the SecondScreen widget.
					'/list': (context) => const ListPage(),
  				},
				title: 'Easy Cart',
				theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.green
				),
				useMaterial3: true,
				)
			)
		);
	}
}