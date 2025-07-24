import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
	const HistoryItem({
		super.key, 
		required this.date,
		required this.total
	});

	final String date, total;

	@override
	Widget build(BuildContext context) {
		return ContainerDefault(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Text(
						date,
						style: TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.w600
						)
					),
					Text(
						PriceUtils.getDisplayPrice(total),
						style:  TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.bold,
							color: Colors.green
						)
					)
				]
			)
		);
	}
}