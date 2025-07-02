import 'package:easy_cart/core/database/product_manager.dart';
import 'package:easy_cart/ui/scan/scan_screen.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'package:easy_cart/data/models/product.dart';

import 'package:easy_cart/ui/cart/cart_item.dart';
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
				model.futureToRun();
				model
				..productsList.onChange.listen(
					(list) => products = list.neu
				)
				..total.onChange.listen(
					(event) => total = event.neu
				);
			},
			builder: (context, model, child) => Scaffold(
				backgroundColor: Colors.white,
				appBar: PreferredSize(
					preferredSize: const Size.fromHeight(80.0), 
					child: CartAppbar(
						total: total,
						onConfirm: () {
							model.cleanCartList();
						}
					)
				),
				floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
				floatingActionButton: FloatingActionButton(
					backgroundColor: Colors.green,
					onPressed: () {
						showModalBottomSheet(
							context: context,
							showDragHandle: true,
							backgroundColor: Colors.white,
							builder: (context) => ScanScreen()
						).whenComplete( (){
							model.getData();
						}
						);
					},
					tooltip: "Run action",
					child: Icon(
						CupertinoIcons.barcode_viewfinder,
						color: Colors.white,
						size: 40,
					)
				),
				body: Column(
					children: [
						Container(
							color: Color(0xFFEFF1F4),
							padding: const EdgeInsets.fromLTRB(15, 24, 15, 15),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									ContainerDefault(
										onPress: (){
											Navigator.pushNamed(
												context, 
												'/list'
											);
										},
										child: Column(
											children: [
												Icon(
													Icons.list,
													size: 30,
													color: Colors.green,
												),
												const SizedBox(height: 5),
												Text(
													'Lista de Compras',
													style: TextStyle(
														fontWeight: FontWeight.bold
													),
												)
											]
										)
									),
									ContainerDefault(
										child: Column(
											children: [
												Icon(
													Icons.history,
													size: 30,
													color: Colors.green,
												),
												const SizedBox(height: 5),
												Text(
													'Compras Anteriores',
													style: TextStyle(
														fontWeight: FontWeight.bold
													),
												)
											]
										)
									)
								]
							)
						),
						Expanded(
							child: Padding(
								padding: const EdgeInsets.all(15),
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
					]
				)
			)
		);
	}
}