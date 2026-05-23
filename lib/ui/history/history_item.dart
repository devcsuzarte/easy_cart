import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
	const HistoryItem({
		super.key,
		required this.date,
		required this.total,
		this.totalItems,
	});

	final String date, total;
	final int? totalItems;

	@override
	Widget build(BuildContext context) {
		return ContainerDefault(
			child: Row(
				children: [
					// ── Ícone de carrinho à esquerda ─────────────────────
					Container(
						width: 44,
						height: 44,
						decoration: BoxDecoration(
							color: kAccentTintColor,
							borderRadius: BorderRadius.circular(AppRadius.sm),
						),
						child: const Icon(
							Icons.shopping_cart_outlined,
							color: kAccentColor,
							size: 22,
						),
					),
					const SizedBox(width: 12),

					// ── Centro: "Compra" + data · N itens ────────────────
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text('Compra', style: TypographyStyle.bodyEmph()),
								const SizedBox(height: 2),
								Text(
									totalItems != null
										? '$date · $totalItems itens'
										: date,
									style: TypographyStyle.labelXs(),
								),
							],
						),
					),
					const SizedBox(width: 8),

					// ── Valor + seta ──────────────────────────────────────
					Column(
						crossAxisAlignment: CrossAxisAlignment.end,
						children: [
							Text(
								PriceUtils.getDisplayPrice(total),
								style: TypographyStyle.mono(size: 14)
									.copyWith(color: kInkColor),
							),
							const SizedBox(height: 2),
							const Icon(
								Icons.north_east,
								size: 14,
								color: kMutedColor,
							),
						],
					),
				],
			),
		);
	}
}
