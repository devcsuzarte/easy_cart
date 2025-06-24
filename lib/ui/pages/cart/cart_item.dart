import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/utils/format.dart';
import 'package:flutter/material.dart';

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
		return Container(
			padding: const EdgeInsets.all(8),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(10),
				boxShadow: [
					BoxShadow(
						 color: Colors.black12,
						offset: Offset(0, 0),
						blurRadius: 14,
						spreadRadius: -3,
					)
				]
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					SizedBox(
						width: MediaQuery.sizeOf(context).width * 0.6,
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
								Text(
									'Quantidade: $amount',
									style: TextStyle(
										fontSize: 15,
										color: Color(0xFF474747)
									)
								)
							]
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
		);
	}
}
