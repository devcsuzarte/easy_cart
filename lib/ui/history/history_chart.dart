import 'dart:math';

import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/core/models/history.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Bar chart com até 5 meses de histórico de gastos.
class HistoryChart extends StatelessWidget {
	const HistoryChart({
		super.key,
		required this.history,
		this.insightMessage,
	});

	final List<Cart> history;
	/// Mensagem de insight opcional (ex: "Você gastou R$ 126 a menos que abril").
	final String? insightMessage;

	static const _monthLabels = [
		'jan', 'fev', 'mar', 'abr', 'mai',
		'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez',
	];

	/// Agrega o histórico por mês, retorna até os últimos 5 meses com dados.
	List<_MonthBar> _buildBars() {
		final Map<String, double> map = {};
		for (final cart in history) {
			final dt = DateTime.fromMillisecondsSinceEpoch(int.parse(cart.date));
			final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
			map[key] = (map[key] ?? 0) + PriceUtils.formatedToDouble(cart.total);
		}

		final sorted = map.entries.toList()
			..sort((a, b) => a.key.compareTo(b.key));

		final recent = sorted.length > 5
			? sorted.sublist(sorted.length - 5)
			: sorted;

		final now = DateTime.now();
		return recent.map((e) {
			final parts = e.key.split('-');
			final year  = int.parse(parts[0]);
			final month = int.parse(parts[1]);
			return _MonthBar(
				label: _monthLabels[month - 1],
				total: e.value,
				isCurrent: year == now.year && month == now.month,
			);
		}).toList();
	}

	@override
	Widget build(BuildContext context) {
		final bars = _buildBars();
		if (bars.isEmpty) return const SizedBox.shrink();

		final maxVal = bars.map((b) => b.total).reduce(max);
		const chartHeight = 80.0;

		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: kSurfaceColor,
				borderRadius: BorderRadius.circular(AppRadius.lg),
				boxShadow: AppShadow.sm,
				border: Border.all(color: kHairlineColor),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					// ── Barras ──────────────────────────────────────────
					SizedBox(
						height: chartHeight + 24, // barras + labels
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.end,
							mainAxisAlignment: MainAxisAlignment.spaceAround,
							children: List.generate(bars.length, (index) {
								final bar = bars[index];
								final ratio = maxVal > 0 ? bar.total / maxVal : 0.0;
								final barH = max(ratio * chartHeight, 6.0);
								return Column(
									mainAxisAlignment: MainAxisAlignment.end,
									children: [
										AnimatedContainer(
											duration: const Duration(milliseconds: 400),
											curve: Curves.easeOutCubic,
											width: 28,
											height: barH,
											decoration: BoxDecoration(
												color: bar.isCurrent
													? kAccentColor
													: kInk2Color.withAlpha(50),
												borderRadius: BorderRadius.circular(6),
											),
										).animate(delay: Duration(milliseconds: index * 60))
											.scaleY(
												begin: 0,
												end: 1,
												duration: const Duration(milliseconds: 400),
												curve: Curves.easeOutCubic,
												alignment: Alignment.bottomCenter,
											)
											.fadeIn(duration: const Duration(milliseconds: 300)),
										const SizedBox(height: 6),
										Text(
											bar.label,
											style: TypographyStyle.labelXs().copyWith(
												color: bar.isCurrent ? kAccentColor : kMutedColor,
											),
										),
									],
								);
							}),
						),
					),

					// ── Insight banner (opcional) ────────────────────────
					if (insightMessage != null) ...[
						const SizedBox(height: 12),
						Container(
							width: double.infinity,
							padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
							decoration: BoxDecoration(
								color: kGreenTintColor,
								borderRadius: BorderRadius.circular(AppRadius.sm),
							),
							child: Text(
								insightMessage!,
								style: TypographyStyle.body().copyWith(color: kGreenColor),
							),
						),
					],
				],
			),
		);
	}
}

class _MonthBar {
	final String label;
	final double total;
	final bool isCurrent;

	const _MonthBar({
		required this.label,
		required this.total,
		required this.isCurrent,
	});
}
