import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartHero extends StatelessWidget {
	const CartHero({
		super.key,
		required this.total,
		required this.productCount,
		required this.onConfirm,
	});

	final String total;
	final int productCount;
	final VoidCallback onConfirm;

	/// Divide "R$ 1.234,56" em três partes: prefixo, inteiro e centavos.
	List<String> _splitTotal(String raw) {
		final display = PriceUtils.getDisplayPrice(raw);
		final comma = display.split(',');
		final intPart = comma.first.replaceFirst('R\$ ', '').trim();
		final centsPart = comma.length > 1 ? comma[1] : '00';
		return [intPart, centsPart];
	}

	@override
	Widget build(BuildContext context) {
		final parts = _splitTotal(total);
		final intPart = parts[0];
		final centsPart = parts[1];

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// ── Chips de contexto ──────────────────────────────────────
				Row(
					children: [
						_Chip(
							color: kAccentTintColor,
							child: Row(
								mainAxisSize: MainAxisSize.min,
								children: [
									Container(
										width: 7,
										height: 7,
										decoration: const BoxDecoration(
											color: kAccentColor,
											shape: BoxShape.circle,
										),
									).animate(onPlay: (c) => c.repeat(reverse: true))
										.scaleXY(begin: 1.0, end: 1.4, duration: const Duration(milliseconds: 800)),
									const SizedBox(width: 6),
									Text(
										'ao vivo',
										style: TypographyStyle.labelXs()
											.copyWith(color: kAccentInkColor),
									),
								],
							),
						),
						const SizedBox(width: 8),
						_Chip(
							color: kSurface3Color,
							child: Text(
								'comprando agora',
								style: TypographyStyle.labelXs(),
							),
						),
					],
				),
				const SizedBox(height: 14),

				// ── Label "total estimado" ─────────────────────────────────
				Text('total estimado', style: TypographyStyle.labelXs()),
				const SizedBox(height: 4),

				// ── Total hero — R$ + inteiro grande + centavos pequenos ───
				AnimatedSwitcher(
					duration: const Duration(milliseconds: 200),
					child: RichText(
						key: ValueKey('$intPart$centsPart'),
						text: TextSpan(
							children: [
								TextSpan(
									text: 'R\$ ',
									style: TypographyStyle.h2().copyWith(color: kMutedColor),
								),
								TextSpan(
									text: intPart,
									style: TypographyStyle.displayXL().copyWith(
										color: kInkColor,
										fontFeatures: const [FontFeature.tabularFigures()],
									),
								),
								TextSpan(
									text: ',$centsPart',
									style: TypographyStyle.h2().copyWith(color: kMutedColor),
								),
							],
						),
					),
				),
				const SizedBox(height: 18),

				// ── Botão "Concluir" — ação secundária ────────────────────
				GestureDetector(
					onTap: onConfirm,
					child: Container(
						padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
						decoration: BoxDecoration(
							color: kSurface2Color,
							borderRadius: BorderRadius.circular(AppRadius.pill),
							border: Border.all(color: kHairline2Color),
						),
						child: Text(
							'Concluir compra',
							style: TypographyStyle.bodyEmph().copyWith(color: kInk2Color),
						),
					),
				),
				const SizedBox(height: 22),
			],
		);
	}
}

/// Chip genérico com cor de fundo e raio pill.
class _Chip extends StatelessWidget {
	const _Chip({required this.color, required this.child});

	final Color color;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
			decoration: BoxDecoration(
				color: color,
				borderRadius: BorderRadius.circular(AppRadius.pill),
			),
			child: child,
		);
	}
}
