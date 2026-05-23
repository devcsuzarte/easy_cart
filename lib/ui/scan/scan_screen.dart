import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/models/product.dart';
import 'package:easy_cart/ui/scan/scan_viewmodel.dart';
import 'package:easy_cart/ui/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ScanScreen extends StatefulWidget {
	final bool isEditing;
	final Product? product;

	const ScanScreen({
		super.key,
		this.isEditing = false,
		this.product,
	});

	@override
	State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

	final TextEditingController textLabelController = TextEditingController(),
		textPriceController = TextEditingController();
	final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter.currency(
		locale: 'pt-br',
		decimalDigits: 2,
		symbol: 'R\$',
	);

	String label = '',
		price = '0,00',
		total = '0,00';
	int amount = 1;

	void dismiss() => Navigator.pop(context);

	void listener(ScanState state) {
		if (state == ScanState.labelEmpty) {
			DefaultDialog(
				context: context,
				defaultFunction: () { Navigator.pop(context); },
				title: 'Erro ao adicionar item',
				message: 'Necessário inserir o nome do produto',
				buttonTitle: 'Entendi',
			).showDefaultDialog();
			return;
		}
		if (state == ScanState.priceEmpty) {
			DefaultDialog(
				context: context,
				defaultFunction: () { Navigator.pop(context); },
				title: 'Erro ao adicionar item',
				message: 'Necessário inserir o preço do produto',
				buttonTitle: 'Entendi',
			).showDefaultDialog();
			return;
		}
		if (state == ScanState.addSucceeded) {
			Navigator.pop(context);
			return;
		}
	}

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder.reactive(
			viewModelBuilder: () => ScanViewmodel(
				productManager: context.read<ProductManager>(),
				isEditing: widget.isEditing,
				product: widget.product,
			),
			onViewModelReady: (model) {
				model
				..state.onChange.listen((state) => listener(state.neu))
				..label.onChange.listen((event) {
					label = event.neu;
					textLabelController.text = label;
				})
				..price.onChange.listen((event) {
					price = event.neu;
					textPriceController.text = _formatter.formatString(price);
				})
				..total.onChange.listen((event) {
					total = _formatter.formatString(event.neu);
				})
				..amount.onChange.listen((event) => amount = event.neu);
			},
			builder: (context, model, child) => InkWell(
				enableFeedback: false,
				highlightColor: Colors.transparent,
				splashColor: Colors.transparent,
				onTap: () { FocusScope.of(context).unfocus(); },
				child: Container(
					height: MediaQuery.of(context).size.height * 0.85,
					padding: EdgeInsets.fromLTRB(
						18, 0, 18,
						24 + MediaQuery.of(context).viewInsets.bottom,
					),
					child: SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [

								// ── 1. Header: tile + chip + campo nome ──────────
								Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										// Tile 88×88 — placeholder com ícone etiqueta
										Container(
											width: 88,
											height: 88,
											decoration: BoxDecoration(
												color: widget.isEditing ? kSurface3Color : kAccentTintColor,
												borderRadius: BorderRadius.circular(AppRadius.lg),
											),
											child: Icon(
												widget.isEditing ? Icons.edit_outlined : Icons.label_outline,
												color: widget.isEditing ? kInk2Color : kAccentColor,
												size: 36,
											),
										),
										const SizedBox(width: 12),
										Expanded(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													// Chip contextual
													Container(
														padding: const EdgeInsets.symmetric(
															horizontal: 10,
															vertical: 5,
														),
														decoration: BoxDecoration(
															color: widget.isEditing
																? kSurface3Color
																: kAccentTintColor,
															borderRadius: BorderRadius.circular(AppRadius.pill),
														),
														child: Text(
															widget.isEditing
																? 'Editar item'
																: '✨ Detectado pela foto',
															style: TypographyStyle.labelXs().copyWith(
																color: widget.isEditing
																	? kInk2Color
																	: kAccentInkColor,
															),
														),
													),
													const SizedBox(height: 10),
													// Label semântico + campo de texto do produto
													Text('produto', style: TypographyStyle.labelXs()),
													TextFormField(
														controller: textLabelController,
														textAlign: TextAlign.start,
														maxLines: 2,
														minLines: 1,
														style: TypographyStyle.h2(),
														decoration: InputDecoration(
															hintText: 'Nome do produto',
															hintStyle: TypographyStyle.h2()
																.copyWith(color: kMuted2Color),
															border: InputBorder.none,
															isDense: true,
															contentPadding: EdgeInsets.zero,
														),
													),
												],
											),
										),
									],
								),
								const SizedBox(height: 16),

								// ── 2. Preço unitário ─────────────────────────────
								Container(
									padding: const EdgeInsets.symmetric(
										horizontal: 16,
										vertical: 12,
									),
									decoration: BoxDecoration(
										color: kSurface2Color,
										borderRadius: BorderRadius.circular(14),
									),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text('preço unit.', style: TypographyStyle.labelXs()),
											TextFormField(
												controller: textPriceController,
												textAlign: TextAlign.start,
												textAlignVertical: TextAlignVertical.center,
												inputFormatters: <TextInputFormatter>[_formatter],
												keyboardType: TextInputType.number,
												style: TypographyStyle.display().copyWith(
													fontFeatures: const [FontFeature.tabularFigures()],
												),
												decoration: const InputDecoration(
													border: InputBorder.none,
													isDense: true,
													contentPadding: EdgeInsets.zero,
												),
												onChanged: (value) {
													if (value.isEmpty) {
														textPriceController.text =
															_formatter.formatString('0');
													}
													model.onPriceChanged(value);
												},
											),
										],
									),
								),
								const SizedBox(height: 12),

								// ── 3. Quantidade ─────────────────────────────────
								Container(
									padding: const EdgeInsets.symmetric(
										horizontal: 16,
										vertical: 12,
									),
									decoration: BoxDecoration(
										color: kSurface2Color,
										borderRadius: BorderRadius.circular(14),
									),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Text('quantidade', style: TypographyStyle.labelXs()),
											Row(
												children: [
													_StepperButton(
														icon: Icons.remove,
														onTap: () => model.decreaseAmount(),
														isPrimary: false,
													),
													Padding(
														padding: const EdgeInsets.symmetric(
															horizontal: 18,
														),
														child: Text(
															'$amount×',
															style: TypographyStyle.h2().copyWith(
																fontFeatures: const [
																	FontFeature.tabularFigures()
																],
															),
														),
													),
													_StepperButton(
														icon: Icons.add,
														onTap: () => model.increaseAmount(),
														isPrimary: true,
													),
												],
											),
										],
									),
								),
								const SizedBox(height: 8),

								// ── 4. Chips de refresh (apenas não-edição) ────────
								if (!widget.isEditing)
									Row(
										children: [
											TextButton(
												onPressed: () => model.refreshLabel(),
												child: Text(
													'outra etiqueta',
													style: TypographyStyle.body()
														.copyWith(color: kAccentColor),
												),
											),
											TextButton(
												onPressed: () => model.refreshPrice(),
												child: Text(
													'outro preço',
													style: TypographyStyle.body()
														.copyWith(color: kAccentColor),
												),
											),
										],
									),

								const SizedBox(height: 16),

								// ── 5. Botões de ação ──────────────────────────────
								if (!widget.isEditing)
									Row(
										children: [
											// Outra foto — reabre câmera
											Expanded(
												child: OutlinedButton(
													style: OutlinedButton.styleFrom(
														foregroundColor: kInkColor,
														side: const BorderSide(
															color: kHairline2Color,
															width: 1.5,
														),
														padding: const EdgeInsets.symmetric(vertical: 14),
														shape: RoundedRectangleBorder(
															borderRadius: BorderRadius.circular(AppRadius.md),
														),
													),
													onPressed: () => model.scanLabel(),
													child: Text(
														'Outra foto',
														style: TypographyStyle.bodyEmph(),
													),
												),
											),
											const SizedBox(width: 12),
											// Adicionar · R$ total
											Expanded(
												flex: 2,
												child: ElevatedButton(
													style: ElevatedButton.styleFrom(
														backgroundColor: kAccentColor,
														foregroundColor: Colors.white,
														elevation: 0,
														padding: const EdgeInsets.symmetric(vertical: 14),
														shape: RoundedRectangleBorder(
															borderRadius: BorderRadius.circular(AppRadius.md),
														),
													),
													onPressed: () {
														model.addItem(
															title: textLabelController.text,
															price: textPriceController.text,
														);
													},
													child: Text(
														'Adicionar · $total',
														style: TypographyStyle.bodyEmph().copyWith(
															color: Colors.white,
															fontFeatures: const [
																FontFeature.tabularFigures()
															],
														),
													),
												),
											),
										],
									)
								else
									SizedBox(
										width: double.infinity,
										child: ElevatedButton(
											style: ElevatedButton.styleFrom(
												backgroundColor: kAccentColor,
												foregroundColor: Colors.white,
												elevation: 0,
												padding: const EdgeInsets.symmetric(vertical: 14),
												shape: RoundedRectangleBorder(
													borderRadius: BorderRadius.circular(AppRadius.md),
												),
											),
											onPressed: () {
												model.updateProduct(
													textLabelController.text,
													textPriceController.text,
													amount,
												).whenComplete(() { dismiss(); });
											},
											child: Text(
												'Salvar alterações',
												style: TypographyStyle.bodyEmph()
													.copyWith(color: Colors.white),
											),
										),
									),
							],
						),
					),
				),
			),
		);
	}
}

/// Botão circular do stepper — visual inline gerenciado pelo ViewModel.
class _StepperButton extends StatelessWidget {
	const _StepperButton({
		required this.icon,
		required this.onTap,
		required this.isPrimary,
	});

	final IconData icon;
	final VoidCallback onTap;
	final bool isPrimary;

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: onTap,
			child: Container(
				padding: const EdgeInsets.all(8),
				decoration: BoxDecoration(
					color: isPrimary ? kAccentColor : kSurfaceColor,
					shape: BoxShape.circle,
					border: isPrimary
						? null
						: Border.all(color: kHairlineColor),
				),
				child: Icon(
					icon,
					color: isPrimary ? Colors.white : kInkColor,
					size: 22,
				),
			),
		);
	}
}
