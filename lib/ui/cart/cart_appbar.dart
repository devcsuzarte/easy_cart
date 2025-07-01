import 'package:easy_cart/utils/format.dart';
import 'package:flutter/material.dart';

class CartAppbar extends StatelessWidget {
	final String total;
	final Function onCancel, onConfirm;

  	const CartAppbar({
		required this.total,
		required this.onCancel,
		required this.onConfirm,
		super.key
	});

  	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.symmetric(horizontal: 24),
			color: Colors.green,
			child: SafeArea(
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									'Total:',
									style: TextStyle(
										fontSize: 15,
										fontWeight: FontWeight.w700,
										color: Colors.white
									)
								),
								Text(
									FormatUtils.getDisplayPrice(total),
									style: TextStyle(
										fontSize: 28,
										fontWeight: FontWeight.w700,
										color: Colors.white
									)
								)
							]
						),
						Row(
							children: [
								IconButton.filled(
									color: Colors.white,
									onPressed: () => onCancel, 
									icon: Icon(
										Icons.cancel
									)
								),
								IconButton.filled(
									onPressed: () => onConfirm, 
									icon: Icon(
										Icons.check_circle
									)
								)
							]
						)
					]
				)
			)
		);
	}
}
