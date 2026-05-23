import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/style.dart';
import 'package:flutter/material.dart';

class AmountStepper extends StatefulWidget {
	const AmountStepper({
		required this.onDecrease,
		required this.onIncrease,
		super.key
	});

	final Function(int) onIncrease, onDecrease;

	@override
	State<AmountStepper> createState() => _AmountStepperState();
}

class _AmountStepperState extends State<AmountStepper> {
	int value = 1;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(5),
			decoration: BoxDecoration(
				color: kSurface2Color,
				borderRadius: BorderRadius.circular(50),
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					GestureDetector(
						onTap: () {
							if (value > 1) {
								setState(() {
									value--;
									widget.onDecrease(value);
								});
							}
						},
						child: Container(
							padding: const EdgeInsets.all(8),
							decoration: BoxDecoration(
								color: kSurfaceColor,
								shape: BoxShape.circle,
								border: Border.all(color: kHairlineColor),
							),
							child: const Icon(Icons.remove, color: kInkColor, size: 30),
						),
					),
					const SizedBox(width: 18),
					Text('${value}x', style: TypographyStyle.display()),
					const SizedBox(width: 18),
					GestureDetector(
						onTap: () {
							setState(() {
								value++;
								widget.onIncrease(value);
							});
						},
						child: Container(
							padding: const EdgeInsets.all(8),
							decoration: const BoxDecoration(
								color: kAccentColor,
								shape: BoxShape.circle,
							),
							child: const Icon(Icons.add, color: Colors.white, size: 30),
						),
					),
				],
			),
		);
	}
}
