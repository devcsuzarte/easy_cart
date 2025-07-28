import 'package:easy_cart/ui/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';

import 'package:easy_cart/core/models/product.dart';
import 'package:easy_cart/core/managers/product_manager.dart';

import 'package:easy_cart/ui/scan/scan_screen.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:easy_cart/ui/widgets/dialog.dart';
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
							DefaultDialog(
								context: context, 
								defaultFunction: (){
									model.cleanCartList();
									Navigator.pop(context);
								},
								altFunctionMessage: 'Cancelar',
								title: 'Finalizar carrinho', 
								message: 'Todos os itens serão deletados do seu carrinho', 
								buttonTitle: 'Confirmar',
								primaryButtonDestructive: true
							).showDefaultDialog();
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
							isScrollControlled: true,
							backgroundColor: Colors.white,
							builder: (context) => ScanScreen()
						).whenComplete( (){
							model.getData();
						}
						);
					},
					tooltip: "Run action",
					child: Icon(
						Icons.add_shopping_cart_rounded,
						color: Colors.white,
						size: 35
					)
				),
				body: Skeletonizer(
					enabled: model.isBusy,
				  child: Column(
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
				  						onPress: (){
				  							Navigator.pushNamed(
				  								context,
				  								'/history'
				  							);
				  						},
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
				  									)
				  								)
				  							]
				  						)
				  					)
				  				]
				  			)
				  		),

				  		(!model.isBusy && products.isNotEmpty) ? Expanded(
				  			child: Padding(
				  				padding: const EdgeInsets.all(15),
				  				child: ListView.separated(
				  					itemBuilder: (context, index) => Skeleton.leaf(
				  					  child: CartItem(
				  					  	onPress: () {
				  					  		showModalBottomSheet(
				  					  			context: context,
				  					  			showDragHandle: true,
				  					  			builder: (context) => ScanScreen(
				  					  				isEditing: true,
				  					  				product: products[index],
				  					  			)
				  					  		).whenComplete(() {
				  					  				model.getData();
				  					  			}
				  					  		);
				  					  	},
				  					  	onHold: () {
				  					  		DefaultDialog(
				  					  			context: context,
				  					  			defaultFunction: (){
				  					  				if (products[index].id != null) {
				  					  					model.deleteProduct(products[index].id!);
				  					  				}
				  					  				Navigator.pop(context);
				  					  			},
				  					  			altFunctionMessage: 'Cancelar',
				  					  			title: 'Confirmar exclusão',
				  					  			message: 'O item será deletado do carrinho',
				  					  			buttonTitle: 'Confirmar',
				  					  			primaryButtonDestructive: true
				  					  		).showDefaultDialog();
				  					  	},
				  					  	label: products[index].title,
				  					  	amount: products[index].amount,
				  					  	price: products[index].price
				  					  ),
				  					),
				  					separatorBuilder: (context, index) => const SizedBox(height: 10),
				  					itemCount: products.length,
				  				)
				  			)
				  		) : Align(
				  			child: Empty(
				  				imgUrl: 'assets/cart.png',
				  				title: 'Clique no botão abaixo para adicionar itens ao carrinho',
				  			),
				  		)
				  	]
				  ),
				)
			)
		);
	}
}