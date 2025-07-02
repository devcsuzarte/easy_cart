import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/utils/format.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.label,
    required this.amount,
    required this.price});

  final String label;
  final int amount;
  final String price;

	@override
	Widget build(BuildContext context) {
		return ContainerDefault(
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						label,
						softWrap: true,
						style: TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.w600
						)
					),
					const SizedBox(height: 5),
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Text(
								'Quantidade: $amount',
								style: TextStyle(
									fontSize: 15,
									color: Color(0xFF474747)
								)
							),
							Text(
								FormatUtils.getDisplayPrice(price),
								style:  TextStyle(
									fontSize: 18,
									fontWeight: FontWeight.bold,
									color: Colors.green
								)
							)
						]
					)
				]
			),
		);
	}
}
