import 'package:easy_cart/core/database/product_manager.dart';
import 'package:easy_cart/ui/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/data/models/product.dart';

import 'package:easy_cart/ui/cart/cart_item.dart';
import 'package:easy_cart/ui/scan/scan_screen.dart';
import 'package:easy_cart/ui/cart/cart_viewmodel.dart';
import 'package:easy_cart/ui/cart/cart_appbar.dart';

class CartPage extends StatefulWidget {
	const CartPage({super.key});
	@override
	State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

	List<Product> products = List.empty();
	String total = '0.0';

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<CartViewModel>.reactive(
			viewModelBuilder: () => CartViewModel(
				productManager: context.read<ProductManager>()
			),
			onViewModelReady: (model) {
				model
				..productsList.onChange.listen(
					(list) => products = list.neu
				)
				..total.onChange.listen(
					(event) => total = event.neu
				);
			},
			builder: (context, model, child) => Scaffold(
				// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
				// floatingActionButton: FloatingActionButton(
				// 	onPressed: () {
				// 		showModalBottomSheet(
				// 			context: context,
				// 			showDragHandle: true,
				// 			backgroundColor: Colors.white,
				// 			builder: (context) => ScanScreen()
				// 		).whenComplete(
				// 			(){
				// 				model.getData();
				// 			}
				// 		);
				// 	},
				// 	tooltip: "Ler etiqueta",
				// 	child: kFloatingActionIcon
				// ),
				appBar: PreferredSize(
					preferredSize: const Size.fromHeight(80.0), 
					child: CartAppbar(
						total: total, 
						onCancel: () {
							
						}, 
						onConfirm: () {}
					)
				),
				body: Padding(
					padding: const EdgeInsets.all(24),
					child: ListView.separated(
						itemBuilder: (context, index) => CartItem(
							label: products[index].title,
							amount: products[index].amount, 
							price: products[index].price
						),
						separatorBuilder: (context, index) => const SizedBox(height: 10),
						itemCount: products.length,
					)
				)
			)
		);
	}
}