import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget	{
	const CartItem({
		super.key,
		required this.label,
		required this.amount,
		required this.price,
		required this.onHold,
		required this.onPress
	});

	final String label, price;
	final int amount;
	final Function onHold, onPress;

	@override
	Widget build(BuildContext context) {
		return ContainerDefault(
			onPress: () { onPress(); },
			onHold: () { onHold(); },
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
								PriceUtils.getDisplayPrice(price),
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
