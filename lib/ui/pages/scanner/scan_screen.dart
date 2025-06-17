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
				(event) {
					label = event.neu;
					textLabelController.text = label;
				} 
			)
			..price.onChange.listen(
				(event) {
					price = event.neu;
					textPriceController.text = price;
				} 
			);
		},
		builder: (context, model, child) => Column(
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						SizedBox(
							width: MediaQuery.of(context).size.width * 0.8,
							child: TextField(
								controller: textLabelController,
								textAlign: TextAlign.center,
								style: TextStyle(
									fontSize: 24
								),
								decoration: InputDecoration(
									hintText: 'TITULO DO PRODUTO',
									border: InputBorder.none,
									suffixIcon: IconButton(
										onPressed: () {}, 
										icon: Icon(
											Icons.refresh,
											color: Colors.black
										)
									)
								)
							)
						)
					]
				),
				const SizedBox(height: 5),
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						SizedBox(
							width: MediaQuery.of(context).size.width * 0.3,
							child: TextField(
								controller: textPriceController,
								textAlign: TextAlign.center,
								textAlignVertical: TextAlignVertical.center,
								style: TextStyle(
									fontSize: 16
								),
								decoration: InputDecoration(
									hintText: 'RS770,00',
									border: InputBorder.none,
									suffixIcon: IconButton(
										onPressed: () {}, 
										icon: Icon(
											Icons.refresh,
											color: Colors.black
										)
									)
								)
							)
						)
					]
				),
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						IconButton(
							onPressed: (){}, 
							icon: IconButton(
								onPressed: () {}, 
								icon: Icon(
									Icons.add,
									color: Colors.black
								)
							)
						),
						Text(
							'1x',
							style: TextStyle(
								fontSize: 30
							),
						),
						IconButton(
							onPressed: (){}, 
							icon: IconButton(
								onPressed: () {}, 
								icon: Icon(
									Icons.add,
									color: Colors.black
								)
							)
						)
					]
				),
				Row(
					children: [
						Text(
							price,
							style: TextStyle(
								fontSize: 30
							),
						),
						SizedBox(width: 8),
						TextButton.icon(
							style: TextButton.styleFrom(
								backgroundColor: Colors.green,
								foregroundColor: Colors.white
							),
							onPressed: (){}, 
							icon: Icon(
								Icons.shopping_cart
							),
							label: Text(
								'Add item'
							)
						)
					]
				)
			]
		));
	}
}
