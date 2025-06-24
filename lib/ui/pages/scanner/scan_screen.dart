import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_cart/core/database_manager.dart';
import 'package:easy_cart/ui/pages/scanner/scan_viewmodel.dart';
import 'package:easy_cart/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:easy_cart/core/scan_manager.dart';

import 'package:stacked/stacked.dart';

class ScanScreen extends StatefulWidget {

  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

	final TextEditingController textLabelController = TextEditingController();
	final TextEditingController textPriceController = TextEditingController();
	final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter.currency(
		locale: 'pt-br',
		decimalDigits: 2,
		symbol: 'R\$',
		inputDirection: InputDirection.left
	);

	String label = ''; 
	String price = '0,00'; 
	int amount = 1;

  @override
  Widget build(BuildContext context) {
	
	return ViewModelBuilder.reactive(
		viewModelBuilder: () => ScanViewmodel(
			scanManager: context.read<ScanManager>(),
			databaseManager: context.read<DatabaseManager>()
		),
		onViewModelReady: (model) {
			model
			..label.onChange.listen(
				(event) {
					label = event.neu;
					textLabelController.text = label;
				} 
			)
			..price.onChange.listen(
				(event) {
					price = event.neu;
					
					textPriceController.text = _formatter.formatString(price);
				} 
			)
			..amount.onChange.listen(
				(event) => amount = event.neu
			);
		},
		builder: (context, model, child) => Padding(
			padding: const EdgeInsets.all(14.0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					Flexible(
						child: TextFormField(
							controller: textLabelController,
							textAlign: TextAlign.start,
							maxLines: 2,
							minLines: 1,
							style: TextStyle(
								fontSize: 24,
								fontWeight: FontWeight.bold
							),
							decoration: InputDecoration(
								hintText: 'TITULO DO PRODUTO',
								border: InputBorder.none
							)
						)
					),
					const SizedBox(height: 5),
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Container(
								padding: const EdgeInsets.all(5),
								decoration: BoxDecoration(
									color: Color(0xFFF8F9FA),
									borderRadius: BorderRadius.circular(50)
								),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										GestureDetector(
											onTap: (){
												model.decreaseAmount();
											},
											child: Container(
												padding: const EdgeInsets.all(8),
												decoration: BoxDecoration(
													color: Colors.white,
													shape: BoxShape.circle,
													border:  Border.all(
														color: Color(0xFFDEE2E6)
													)
												),
												child: Icon(
													Icons.remove,
													color: Colors.black,
													size: 30
												)
											)
										),
										const SizedBox(width: 18),
										Text(
											'${amount}x',
											style: TextStyle(
												fontSize: 30,
												fontWeight: FontWeight.bold
											),
										),
										const SizedBox(width: 18),
										GestureDetector(
											onTap: (){
												model.increaseAmount();
											},
											child: Container(
												padding: const EdgeInsets.all(8),
												decoration: BoxDecoration(
													color: Colors.white,
													shape: BoxShape.circle,
													border: Border.all(
														color: Color(0xFFDEE2E6)
													)
												),
												child: Icon(
													Icons.add,
													color: Colors.black,
													size: 30
												)
											)
										)
									]
								)
							),

							Flexible(
								child: TextFormField(
									controller: textPriceController,
									textAlign: TextAlign.end,
									textAlignVertical: TextAlignVertical.center,
									inputFormatters: <TextInputFormatter>[
										CurrencyTextInputFormatter.currency(
											locale: 'br',
											decimalDigits: 2,
											symbol: 'R\$ ',
										),
									],
									keyboardType: TextInputType.number,
									style: TextStyle(
										fontSize: 28,
										fontWeight: FontWeight.bold
									),
									decoration: InputDecoration(
										hintText: 'Preço',
										border: InputBorder.none
									)
								)
							)
						]
					),
					
					Padding(
						padding: const EdgeInsets.symmetric(vertical: 24),
						child: Divider(
							color: Colors.grey.shade200,
						)
					),

					Row(
						mainAxisAlignment: MainAxisAlignment.start,
						children: [
							Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									TextButton(
										onPressed: () {
											model.refreshLabel();
										}, 
										child: Text(
											'Atualizar etiqueta',
											style: TextStyle(
												color: Colors.blue,
												fontWeight: FontWeight.bold
											)
										)
									),
									TextButton(
										onPressed: () {
											model.refreshPrice();
										}, 
										child: Text(
											'Atualizar preço',
											style: TextStyle(
												color: Colors.blue,
												fontWeight: FontWeight.bold
											)
										)
									)
								]
							)
						]
					),
					const SizedBox(height: 24.0),
					TextButton(
						style: TextButton.styleFrom(
							backgroundColor: Colors.green,
							foregroundColor: Colors.white
						),
						onPressed: () {
							model.addItem().whenComplete(
								(){
									Navigator.pop(context);
								}
							);
						}, 
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Text(
										'Adicionar ($amount)',
										style: TextStyle(
											fontSize: 16,
											fontWeight: FontWeight.bold
										),
									),
									Text(
										_formatter.formatString(price),
										style: TextStyle(
											fontSize: 16,
											fontWeight: FontWeight.bold
										)
									)
								]
							)
						)
					)
				]
			)
		));
	}
}
