import 'package:flutter/material.dart';

class DefaultNavBar extends StatelessWidget {
	const DefaultNavBar({super.key, required this.selectedIndex, required this.onTap});

	final int selectedIndex;
	final Function(int) onTap;
	@override
	Widget build(BuildContext context) {
		return BottomAppBar(
			child: Row(
				children: [
					IconButton(
						icon: Icon(
							Icons.shopping_cart,
						),
						onPressed: () => onTap
					),
					IconButton(
						icon: Icon(
							Icons.list,
						),
						onPressed: () => onTap
					),
				]
			)
		);
	}
}