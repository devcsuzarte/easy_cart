// ignore_for_file: must_be_immutable

import 'package:easy_cart/core/database/shop_list_manager.dart';
import 'package:easy_cart/data/models/shop_item.dart';
import 'package:easy_cart/ui/shop_list/list_add_item.dart';
import 'package:easy_cart/ui/shop_list/list_viewmodel.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({super.key});

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
	List<ShopItem> shopList = List.empty(growable: true);

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<ListViewModel>.reactive(
			viewModelBuilder: () => ListViewModel(
				shopListManager: context.read<ShopListManager>()
			),
			onViewModelReady: (model) {
				model.shopList.onChange.listen(
					(event) => shopList = event.neu
				);
			} ,
			builder: (context, model, widget) => Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.green,
				title: Text(
					'Lista de Compras',
					style: TextStyle(
						fontWeight: FontWeight.bold,
						color: Colors.white
					)
				)
			),
			// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
			// floatingActionButton: FloatingActionButton(
			// 	onPressed: () {
			// 		showModalBottomSheet(
			// 			context: context,
			// 			showDragHandle: true,
			// 			backgroundColor: Colors.white,
			// 			builder: (context) 
			// 				=> ListAddItem(model: model)
			// 		);
			// 	},
			// 	tooltip: 'Ler etiqueta',
			// 	child: Icon(Icons.add)
			// ),
			body: Padding(
				padding: const EdgeInsets.all(24.0),
				child: ListView.separated(
					itemBuilder: (context, index) => ContainerDefault(
						child: ListTile(
							title: Text(
								shopList[index].title
							),
							subtitle: Text(
								'Quantidade ${shopList[index].amount}',
							),
							trailing: Checkbox(
								value: shopList[index].selected, 
								onChanged: (value){
									
								}
							),
						)
					), 
					separatorBuilder: (context, index) => const SizedBox(height: 8), 
					itemCount: shopList.length
					)
				)
			)
		);
	}
}