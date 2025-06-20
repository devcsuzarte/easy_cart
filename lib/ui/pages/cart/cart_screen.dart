import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database_manager.dart';
import 'package:easy_cart/data/models/product.dart';
import 'package:easy_cart/ui/pages/scanner/scan_screen.dart';
import 'package:easy_cart/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/ui/pages/cart/cart_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class CartScreen extends StatefulWidget {
	const CartScreen({super.key});
	@override
	State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

	List<Product> products = List.empty();
	String total = '0.0';

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<CartViewModel>.reactive(
			viewModelBuilder: () => CartViewModel(
				databaseManager: context.read<DatabaseManager>()
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
				floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
				floatingActionButton: FloatingActionButton(
					onPressed: () {
						showModalBottomSheet(
							context: context,
							showDragHandle: true,
							backgroundColor: Colors.white,
							builder: (context) => ScanScreen()
						).whenComplete(
							(){
								model.getData();
							}
						);
					},
					tooltip: "Ler etiqueta",
					child: kFloatingActionIcon
				),
				appBar: AppBar(
					title: Text(
						'Total: ${FormatUtils.getDisplayPrice(total)}'
					),
				),
				body: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 8.0),
				child: ListView.builder(
					itemBuilder: (context, index) => Row(
							children: [
								Text('')
							]
						)
					)
				)
			)
		);
	}
}