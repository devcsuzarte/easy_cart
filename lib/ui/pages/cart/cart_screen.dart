import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/database_manager.dart';
import 'package:easy_cart/data/models/product.dart';
import 'package:easy_cart/ui/pages/cart/cart_item.dart';
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
				appBar: PreferredSize(
					preferredSize: const Size.fromHeight(80.0), 
					child: Container(
						padding: EdgeInsets.symmetric(horizontal: 24),
						color: Colors.green,
						child: SafeArea(
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												'Total:',
												style: TextStyle(
													fontSize: 15,
													fontWeight: FontWeight.w700,
													color: Colors.white
												),
											),
											Text(
												FormatUtils.getDisplayPrice(total),
												style: TextStyle(
													fontSize: 28,
													fontWeight: FontWeight.w700,
													color: Colors.white
												)
											)
										],
									),
									Row(
										children: [
											IconButton.filled(
												color: Colors.white,
												onPressed: () {}, 
												icon: Icon(
													Icons.cancel
												)
											),
											IconButton.filled(
												onPressed: () {}, 
												icon: Icon(
													Icons.check_circle
												)
											)
										],
									)
								]
							)
						)
					)
				),
				body: Padding(
					padding: const EdgeInsets.all(24),
					child: ListView.separated(
						itemBuilder: (context, index) => CartItem(
							label: products[index].title ?? '',
							amount: products[index].amount ?? 0, 
							price: products[index].price ?? ''
						),
						separatorBuilder: (context, index) => const SizedBox(height: 10),
						itemCount: products.length,
					)
				)
			)
		);
	}
}