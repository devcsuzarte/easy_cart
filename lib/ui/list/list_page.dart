// ignore_for_file: must_be_immutable

import 'package:easy_cart/core/managers/list_manager.dart';
import 'package:easy_cart/core/models/shop_item.dart';
import 'package:easy_cart/ui/list/list_add_item.dart';
import 'package:easy_cart/ui/list/list_viewmodel.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
	List<ListItem> shopList = List.empty(growable: true);

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<ListViewModel>.reactive(
			viewModelBuilder: () => ListViewModel(
				listManager: context.read<ListManager>()
			),
			onViewModelReady: (model) {
				model.shopList.onChange.listen(
					(event) => shopList = event.neu
				);
			} ,
			builder: (context, model, widget) => Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.green,
				foregroundColor: Colors.white,
				title: Text(
					'Lista de Compras',
					style: TextStyle(
						fontWeight: FontWeight.w600
					)
				),
				actions: [
					IconButton(
						onPressed: () {}, 
						icon: Icon(Icons.delete)
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
				padding: const EdgeInsets.all(15.0),
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
											'Quantidade: ${shopList[index].amount}',
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