import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
	const CartItem({
		super.key,
		required this.label,
		required this.amount,
		required this.price,
		required this.onHold,
		required this.onPress,
	});

	final String label, price;
	final int amount;
	final Function onHold, onPress;

	/// Cor do tile determinada pelo primeiro caractere do label.
	Color _tileColor() {
		const palette = [
			kAccentSoftColor,
			kGreenSoftColor,
			kSurface3Color,
			kWarnSoftColor,
			kAccentTintColor,
			kGreenTintColor,
		];
		final code = label.isEmpty ? 0 : label.codeUnitAt(0);
		return palette[code % palette.length];
	}

	String get _initial => label.isEmpty ? '?' : label[0].toUpperCase();

	@override
	Widget build(BuildContext context) {
		return ContainerDefault(
			onPress: () { onPress(); },
			onHold: () { onHold(); },
			child: Row(
				children: [
					// ── Prod tile 44×44 ────────────────────────────────────
					Container(
						width: 44,
						height: 44,
						decoration: BoxDecoration(
							color: _tileColor(),
							borderRadius: BorderRadius.circular(AppRadius.sm),
						),
						child: Center(
							child: Text(
								_initial,
								style: TypographyStyle.bodyEmph().copyWith(color: kInk2Color),
							),
						),
					),
					const SizedBox(width: 12),

					// ── Nome + preço ────────────────────────────────────────
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									label,
									softWrap: true,
									style: TypographyStyle.bodyEmph(),
								),
								const SizedBox(height: 2),
								Text(
									PriceUtils.getDisplayPrice(price),
									style: TypographyStyle.mono(size: 14)
										.copyWith(color: kInkColor),
								),
							],
						),
					),
					const SizedBox(width: 8),

					// ── Badge quantidade ────────────────────────────────────
					Container(
						padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
						decoration: BoxDecoration(
							color: kSurface2Color,
							borderRadius: BorderRadius.circular(AppRadius.sm),
						),
						child: Text(
							'$amount×',
							style: TypographyStyle.mono(size: 11),
						),
					),
				],
			),
		);
	}
}
