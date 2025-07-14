import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/managers/list_manager.dart';
import 'package:easy_cart/ui/cart/cart_page.dart';
import 'package:easy_cart/ui/history/history_page.dart';
import 'package:easy_cart/ui/list/list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/utils/scanner.dart';

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
					create: (context) => Scanner()
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
					'/': (context) => const CartPage(),
					'/list': (context) => const ListPage(),
					'/history': (context) => const HistoryPage(),
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