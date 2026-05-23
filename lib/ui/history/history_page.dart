import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/models/history.dart';
import 'package:easy_cart/ui/history/history_chart.dart';
import 'package:easy_cart/ui/history/history_item.dart';
import 'package:easy_cart/ui/history/history_viewmodel.dart';
import 'package:easy_cart/ui/widgets/empty.dart';
import 'package:easy_cart/ui/widgets/navigation_bar.dart';
import 'package:easy_cart/utils/price.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryPage extends StatefulWidget {
	const HistoryPage({super.key});

	@override
	State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

	List<Cart> historyList = List.empty();

	String getConvertedDate(String date) {
		DateTime convertedDate = DateTime.fromMillisecondsSinceEpoch(
			int.parse(date)
		);
		return DateFormat.yMMMd('pt').format(convertedDate);
	}

	/// Agrega os totais por mês. Retorna {YYYY-MM: total}.
	Map<String, double> _monthlyTotals() {
		final Map<String, double> map = {};
		for (final cart in historyList) {
			final dt = DateTime.fromMillisecondsSinceEpoch(int.parse(cart.date));
			final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
			map[key] = (map[key] ?? 0) + PriceUtils.formatedToDouble(cart.total);
		}
		return map;
	}

	/// Mensagem de insight comparando mês atual com o anterior.
	String? _insightMessage(Map<String, double> monthly) {
		final now = DateTime.now();
		final currentKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
		final prev = DateTime(now.year, now.month - 1);
		final prevKey = '${prev.year}-${prev.month.toString().padLeft(2, '0')}';

		final current = monthly[currentKey] ?? 0;
		final previous = monthly[prevKey] ?? 0;

		if (previous <= 0 || current <= 0) return null;
		final diff = previous - current;
		if (diff <= 0) return null;

		final prevMonthLabel = DateFormat('MMMM', 'pt').format(prev);
		return 'Você gastou R\$ ${diff.toStringAsFixed(0)} a menos que $prevMonthLabel. Continua assim.';
	}

	void _onNavTap(int index, BuildContext context) {
		if (index == 0) {
			Navigator.popUntil(context, ModalRoute.withName('/'));
		} else if (index == 1) {
			Navigator.popUntil(context, ModalRoute.withName('/'));
			Navigator.pushNamed(context, '/list');
		}
	}

	@override
	void initState() {
		WidgetsBinding.instance.addPostFrameCallback((_) {
			initializeDateFormatting(
				Localizations.localeOf(context).languageCode, null
			);
		});
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<HistoryViewmodel>.reactive(
			viewModelBuilder: () => HistoryViewmodel(
				productManager: context.read<ProductManager>()
			),
			onViewModelReady: (model) {
				model.history.onChange.listen(
					(list) => historyList = list.neu
				);
			},
			builder: (context, model, widget) {
				final monthly  = _monthlyTotals();
				final now      = DateTime.now();
				final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
				final monthTotal = monthly[monthKey] ?? 0.0;
				final heroLabel  = 'gasto · ${DateFormat('MMM yy', 'pt').format(now)}';
				final insight    = _insightMessage(monthly);

				// Divide "1234.56" em inteiro + centavos para RichText hero
				final totalStr   = monthTotal.toStringAsFixed(2);
				final dotIndex   = totalStr.indexOf('.');
				final intPart    = totalStr.substring(0, dotIndex);
				final centsPart  = totalStr.substring(dotIndex + 1);

				return Scaffold(
					extendBody: true,
					backgroundColor: kBgColor,
					appBar: AppBar(
						backgroundColor: kBgColor,
						foregroundColor: kInkColor,
						elevation: 0,
						scrolledUnderElevation: 0,
						title: Text('Histórico', style: TypographyStyle.h1()),
					),

					bottomNavigationBar: DefaultNavBar(
						selectedIndex: 2,
						onTap: (i) => _onNavTap(i, context),
					),

					body: (!model.isBusy && historyList.isNotEmpty)
						? Skeletonizer(
							enabled: model.isBusy,
							child: SafeArea(
								bottom: false,
								child: ListView(
									padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
									children: [
										// ── Hero "gasto · mai 26" ─────────────────
										Text(heroLabel, style: TypographyStyle.labelXs()),
										const SizedBox(height: 4),
										RichText(
											text: TextSpan(
												children: [
													TextSpan(
														text: 'R\$ ',
														style: TypographyStyle.h2()
															.copyWith(color: kMutedColor),
													),
													TextSpan(
														text: intPart,
														style: TypographyStyle.display().copyWith(
															color: kInkColor,
															fontFeatures: const [
																FontFeature.tabularFigures()
															],
														),
													),
													TextSpan(
														text: ',$centsPart',
														style: TypographyStyle.h2()
															.copyWith(color: kMutedColor),
													),
												],
											),
										),
										const SizedBox(height: 18),

										// ── Gráfico de barras ─────────────────────
										HistoryChart(
											history: historyList,
											insightMessage: insight,
										),
										const SizedBox(height: 22),

										// ── Label "Compras recentes" ──────────────
										Text('Compras recentes', style: TypographyStyle.h3()),
										const SizedBox(height: 12),

										// ── Lista de HistoryItem ──────────────────
										...List.generate(historyList.length, (index) => Padding(
											padding: const EdgeInsets.only(bottom: 8),
											child: Skeleton.leaf(
												child: HistoryItem(
													date: getConvertedDate(historyList[index].date),
													total: historyList[index].total,
													totalItems: historyList[index].totalItems,
												),
											),
										)),
									],
								),
							),
						)
						: Padding(
							padding: const EdgeInsets.symmetric(horizontal: 25.0),
							child: Align(
								alignment: Alignment.center,
								child: Empty(
									imgUrl: 'assets/history.png',
									title: 'Nenhum histórico encontrado',
									subtitle: 'Suas compras concluídas aparecerão aqui.',
								),
							),
						),
				);
			},
		);
	}
}
