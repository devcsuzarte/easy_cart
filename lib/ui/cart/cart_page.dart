import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/ui/cart/cart_hero.dart';
import 'package:easy_cart/ui/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';

import 'package:easy_cart/core/models/product.dart';
import 'package:easy_cart/core/managers/product_manager.dart';

import 'package:easy_cart/ui/scan/scan_screen.dart';
import 'package:easy_cart/ui/widgets/dialog.dart';
import 'package:easy_cart/ui/cart/cart_item.dart';
import 'package:easy_cart/ui/cart/cart_viewmodel.dart';
import 'package:easy_cart/ui/widgets/navigation_bar.dart';

class CartPage extends StatefulWidget {
	const CartPage({super.key});
	@override
	State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

	List<Product> products = List.empty();
	String total = '0.0';

	void onCleanCartPressed(Function onConfirm) {
		if (products.isEmpty) {
			DefaultDialog(
				context: context,
				defaultFunction: () { onConfirm(); },
				title: 'Sua lista está vazia',
				message: 'Clique no carrinho para adicionar itens',
				buttonTitle: 'Entendi',
			).showDefaultDialog();
			return;
		}

		DefaultDialog(
			context: context,
			defaultFunction: () { onConfirm(); },
			altFunctionMessage: 'Cancelar',
			title: 'Finalizar carrinho',
			message: 'Todos os itens serão deletados do seu carrinho',
			buttonTitle: 'Confirmar',
			primaryButtonDestructive: true,
		).showDefaultDialog();
	}

	void _onNavTap(int index, BuildContext context) {
		if (index == 1) Navigator.pushNamed(context, '/list');
		if (index == 2) Navigator.pushNamed(context, '/history');
	}

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<CartViewModel>.reactive(
			viewModelBuilder: () => CartViewModel(
				productManager: context.read<ProductManager>()
			),
			onViewModelReady: (model) {
				model.futureToRun();
				model
				..productsList.onChange.listen(
					(list) => products = list.neu
				)
				..total.onChange.listen(
					(event) => total = event.neu
				);
			},
			builder: (context, model, child) => Scaffold(
				extendBody: true,

				// ── FAB câmera persimmon 64×64 com borda kBgColor ──────────
				floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
				floatingActionButton: Container(
					width: 72,
					height: 72,
					decoration: const BoxDecoration(
						color: kBgColor,
						shape: BoxShape.circle,
					),
					child: Padding(
						padding: const EdgeInsets.all(4),
						child: FloatingActionButton(
							backgroundColor: kAccentColor,
							elevation: 4,
							onPressed: () {
								showModalBottomSheet(
									context: context,
									showDragHandle: true,
									isScrollControlled: true,
									backgroundColor: Colors.white,
									builder: (context) => ScanScreen()
								).whenComplete(() {
									model.getData();
								});
							},
							tooltip: 'Adicionar item',
							child: const Icon(Icons.photo_camera, color: Colors.white, size: 28),
						),
					),
				),

				// ── Tab bar pill flutuante inferior ────────────────────────
				bottomNavigationBar: DefaultNavBar(
					selectedIndex: 0,
					onTap: (i) => _onNavTap(i, context),
				),

				body: Skeletonizer(
					enabled: model.isBusy,
					child: SafeArea(
						bottom: false,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								// ── CartHero — total dominante ─────────────
								Padding(
									padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
									child: CartHero(
										total: total,
										productCount: products.length,
										onConfirm: () {
											onCleanCartPressed(() {
												model.cleanCartList();
												Navigator.pop(context);
											});
										},
									),
								),

								// ── Header "N itens" ────────────────────────
								if (products.isNotEmpty)
									Padding(
										padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
										child: Text(
											'${products.length} ${products.length == 1 ? 'item' : 'itens'}',
											style: TypographyStyle.h3(),
										),
									),

								// ── Lista ou estado vazio ───────────────────
								if (!model.isBusy && products.isNotEmpty)
									Expanded(
										child: Padding(
											padding: const EdgeInsets.symmetric(horizontal: 18),
											child: ListView.separated(
												padding: const EdgeInsets.only(bottom: 120),
												itemBuilder: (context, index) => Skeleton.leaf(
													child: CartItem(
														onPress: () {
															showModalBottomSheet(
																context: context,
																showDragHandle: true,
																builder: (context) => ScanScreen(
																	isEditing: true,
																	product: products[index],
																)
															).whenComplete(() {
																model.getData();
															});
														},
														onHold: () {
															DefaultDialog(
																context: context,
																defaultFunction: () {
																	if (products[index].id != null) {
																		model.deleteProduct(products[index].id!);
																	}
																	Navigator.pop(context);
																},
																altFunctionMessage: 'Cancelar',
																title: 'Confirmar exclusão',
																message: 'O item será deletado do carrinho',
																buttonTitle: 'Confirmar',
																primaryButtonDestructive: true,
															).showDefaultDialog();
														},
														label: products[index].title,
														amount: products[index].amount,
														price: products[index].price,
													),
												),
												separatorBuilder: (context, index) => const SizedBox(height: 10),
												itemCount: products.length,
											),
										),
									)
								else
									Expanded(
										child: Align(
											alignment: Alignment.center,
											child: Empty(
												imgUrl: 'assets/cart.png',
												title: 'Comece sua lista',
												subtitle: 'Tire foto da etiqueta — a gente lê nome e preço automaticamente.',
											),
										),
									),
							],
						),
					),
				),
			)
		);
	}
}
