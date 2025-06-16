import 'package:easy_cart/ui/pages/scanner/scan_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
	
	String label = ''; 
	String price = '0,00'; 
	List<String> labelsList = List.empty();
  	List<String> priceList = List.empty();


  int labelIndex = 0;
  int priceIndex = 0;
  int amount = 1;

  @override
  Widget build(BuildContext context) {
	
	return ViewModelBuilder.reactive(
		viewModelBuilder: () => ScanViewmodel(
			scanManager: context.read<ScanManager>()
		),
		onViewModelReady: (model) {
			model
			..labelsList.onChange.listen(
				(list) => labelsList = list.neu
			)
			..pricesList.onChange.listen(
				(list) => priceList = list.neu
			)
			..label.onChange.listen(
				(event) => label = event.neu
			)
			..price.onChange.listen(
				(event) => price = event.neu
			);
		},
		builder: (context, model, child) => Padding(
			padding: const EdgeInsets.symmetric(horizontal: 20.0),
			child: Text('Valor: $label')
			),
		);
	}
}
