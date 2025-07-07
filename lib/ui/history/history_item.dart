import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:easy_cart/utils/format.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
	const HistoryItem({super.key, required this.purschaseDate, required this.totalItems, required this.totalValue, required this.showItems});

	final String purschaseDate, totalItems, totalValue;
	final bool showItems;

	@override
	Widget build(BuildContext context) {
		return ContainerDefault(
			child: Column(
				children: [
					Row(
						children: [
							Column(
								children: [
									Text(
										FormatUtils.getDisplayPrice(totalValue)
									),
									Text(
										'Data da compra: $purschaseDate'
									),
									Text(
										'$totalItems itens'
									)
								],
							),
							Icon(
							showItems ?
								Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
							)
						]
					),

					if(showItems)
					SizedBox(
						//list of items
					)
				],
			)
		);
	}
}