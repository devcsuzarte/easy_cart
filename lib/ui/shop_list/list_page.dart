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
						color: Colors.white,
						fontWeight: FontWeight.w600
					)
				),
				centerTitle: false,
				actions: [
					IconButton(
						onPressed: () {}, 
						icon: Icon(
							color: Colors.white,
							Icons.delete
						)
					),
					IconButton(
						color: Colors.white,
						onPressed: () {
							showModalBottomSheet(
								context: context,
								showDragHandle: true,
								backgroundColor: Colors.white,
								builder: (context) 
									=> ListAddItem(model: model)
							);
						}, 
						icon: Icon(
							Icons.add_box
						)
					),
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(24.0),
				child: ListView.separated(
					itemBuilder: (context, index) => ContainerDefault(
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											shopList[index].title,
											style: TextStyle(
												fontSize: 18,
												fontWeight: FontWeight.w600
											)
										),
										Text(
											'Quantidade ${shopList[index].amount}',
											style: TextStyle(
												fontSize: 15,
												color: Color(0xFF474747)
											)
										)
									]
								),
								Checkbox(
									value: shopList[index].selected, 
									onChanged: (value) {
										model.toggleSelected(id: shopList[index].id!, newStatus: value!);
									}
								)
							]
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