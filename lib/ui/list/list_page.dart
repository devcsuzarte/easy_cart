// ignore_for_file: must_be_immutable

import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/core/managers/list_manager.dart';
import 'package:easy_cart/core/models/list_item.dart';
import 'package:easy_cart/ui/list/list_add_item.dart';
import 'package:easy_cart/ui/list/list_viewmodel.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:easy_cart/ui/widgets/dialog.dart';
import 'package:easy_cart/ui/widgets/empty.dart';
import 'package:easy_cart/ui/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';

class ListPage extends StatefulWidget {
	const ListPage({super.key});

	@override
	State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
	List<ListItem> shopList = List.empty(growable: true);

	void _showCleanListDialog(Function action) {
		if (shopList.isEmpty) {
			DefaultDialog(
				context: context,
				defaultFunction: () { Navigator.pop(context); },
				title: 'Sua lista está vazia',
				message: 'Clique no botão abaixo para adicionar itens',
				buttonTitle: 'Entendi',
			).showDefaultDialog();
			return;
		}
		DefaultDialog(
			context: context,
			defaultFunction: () {
				action();
				Navigator.pop(context);
			},
			primaryButtonDestructive: true,
			altFunctionMessage: 'Cancelar',
			title: 'Deseja limpar a lista',
			message: 'Todos os itens serão removidos',
			buttonTitle: 'Confirmar',
		).showDefaultDialog();
	}

	void _showDeleteItemDialog(Function action) {
		DefaultDialog(
			context: context,
			defaultFunction: () {
				action();
				Navigator.pop(context);
			},
			primaryButtonDestructive: true,
			altFunctionMessage: 'Cancelar',
			title: 'Confirmar exclusão',
			message: 'O item será deletado da sua lista',
			buttonTitle: 'Confirmar',
		).showDefaultDialog();
	}

	void _onNavTap(int index, BuildContext context) {
		if (index == 0) Navigator.pop(context);
		if (index == 2) Navigator.pushNamed(context, '/history');
	}

	void _showAddItem(BuildContext context, ListViewModel model) {
		showModalBottomSheet(
			context: context,
			showDragHandle: true,
			isScrollControlled: true,
			useSafeArea: true,
			backgroundColor: kBgColor,
			builder: (context) => ListAddItem(model: model),
		);
	}

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<ListViewModel>.reactive(
			viewModelBuilder: () => ListViewModel(
				listManager: context.read<ListManager>()
			),
			onViewModelReady: (model) {
				model.shopList.onChange.listen(
					(event) => shopList = event.neu
				);
			},
			builder: (context, model, widget) {
				final selectedCount = shopList.where((i) => i.selected).length;
				final totalCount = shopList.length;

				return Scaffold(
					extendBody: true,
					backgroundColor: kBgColor,
					appBar: AppBar(
						backgroundColor: kBgColor,
						foregroundColor: kInkColor,
						elevation: 0,
						scrolledUnderElevation: 0,
						title: Text('Lista de compras', style: TypographyStyle.h1()),
						actions: [
							IconButton(
								onPressed: () {
									_showCleanListDialog(() { model.cleanList(); });
								},
								icon: const Icon(Icons.delete_outline),
								color: kMutedColor,
							),
						],
					),

					// FAB kInkColor 56×56 — distinto do FAB câmera da Home
					floatingActionButton: FloatingActionButton(
						backgroundColor: kInkColor,
						foregroundColor: Colors.white,
						elevation: 4,
						onPressed: () => _showAddItem(context, model),
						child: const Icon(Icons.add, size: 28),
					),

					bottomNavigationBar: DefaultNavBar(
						selectedIndex: 1,
						onTap: (i) => _onNavTap(i, context),
					),

					body: SafeArea(
						bottom: false,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								// ── Progresso "X de Y no carrinho" ──────────────
								if (totalCount > 0)
									Padding(
										padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Row(
													children: [
														Text(
															'$selectedCount de $totalCount no carrinho',
															style: TypographyStyle.labelXs(),
														),
														if (selectedCount == totalCount && totalCount > 0) ...[
															const SizedBox(width: 8),
															Container(
																padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
																decoration: BoxDecoration(
																	color: kGreenSoftColor,
																	borderRadius: BorderRadius.circular(AppRadius.pill),
																),
																child: Text(
																	'completo',
																	style: TypographyStyle.labelXs()
																		.copyWith(color: kGreenColor),
																),
															),
														],
													],
												),
												const SizedBox(height: 6),
												ClipRRect(
													borderRadius: BorderRadius.circular(AppRadius.pill),
													child: LinearProgressIndicator(
														value: totalCount > 0 ? selectedCount / totalCount : 0,
														backgroundColor: kSurface3Color,
														color: kGreenColor,
														minHeight: 4,
													),
												),
											],
										),
									),

								// ── Lista ou estado vazio ────────────────────────
								(!model.isBusy && shopList.isNotEmpty)
									? Expanded(
										child: Skeletonizer(
											enabled: model.isBusy,
											child: Padding(
												padding: const EdgeInsets.symmetric(horizontal: 15),
												child: ListView.separated(
													padding: const EdgeInsets.only(bottom: 120),
													itemBuilder: (context, index) => Skeleton.leaf(
														child: ContainerDefault(
															onHold: () {
																_showDeleteItemDialog(() {
																	if (shopList[index].id != null) {
																		model.deleteItem(shopList[index].id!);
																	}
																});
															},
															child: Row(
																children: [
																	// ── Checkbox custom animado ──────────
																	GestureDetector(
																		onTap: () {
																			model.toggleSelected(
																				id: shopList[index].id!,
																				newStatus: !shopList[index].selected,
																			);
																		},
																		child: AnimatedContainer(
																			duration: const Duration(milliseconds: 200),
																			width: 22,
																			height: 22,
																			decoration: BoxDecoration(
																				color: shopList[index].selected
																					? kGreenColor
																					: Colors.transparent,
																				borderRadius: BorderRadius.circular(6),
																				border: Border.all(
																					color: shopList[index].selected
																						? kGreenColor
																						: kHairline2Color,
																					width: 1.5,
																				),
																			),
																			child: shopList[index].selected
																				? const Icon(
																					Icons.check,
																					color: Colors.white,
																					size: 14,
																				)
																				: null,
																		),
																	),
																	const SizedBox(width: 12),

																	// ── Nome + quantidade com line-through ──
																	Expanded(
																		child: AnimatedOpacity(
																			duration: const Duration(milliseconds: 250),
																			opacity: shopList[index].selected ? 0.45 : 1.0,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					AnimatedDefaultTextStyle(
																						duration: const Duration(milliseconds: 250),
																						style: TypographyStyle.bodyEmph().copyWith(
																							decoration: shopList[index].selected
																								? TextDecoration.lineThrough
																								: TextDecoration.none,
																							decorationColor: kMutedColor,
																						),
																						child: Text(shopList[index].title),
																					),
																					Text(
																						'${shopList[index].amount} unid.',
																						style: TypographyStyle.labelXs(),
																					),
																				],
																			),
																		),
																	),
																],
															),
														),
													),
													separatorBuilder: (context, index) => const SizedBox(height: 8),
													itemCount: shopList.length,
												),
											),
										),
									)
									: Expanded(
										child: Align(
											alignment: Alignment.center,
											child: Empty(
												imgUrl: 'assets/list.svg',
												title: 'Comece sua lista',
												subtitle: 'Anote o que precisa comprar — riscamos os itens automaticamente quando você adicionar no carrinho.',
											),
										),
									),
							],
						),
					),
				);
			},
		);
	}
}
