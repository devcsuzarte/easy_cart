// ignore_for_file: must_be_immutable

import 'package:easy_cart/core/models/list_item.dart';
import 'package:easy_cart/ui/list/list_viewmodel.dart';
import 'package:easy_cart/ui/widgets/stepper.dart';
import 'package:easy_cart/utils/theme.dart';
import 'package:flutter/material.dart';

class ListAddItem extends StatefulWidget {
	
	ListAddItem({
		required this.model,
		super.key
	});

  late ListViewModel model;

  @override
  State<ListAddItem> createState() => _ListAddItemState();
}

class _ListAddItemState extends State<ListAddItem> {
  @override
  Widget build(BuildContext context) {
	final TextEditingController textTitleController = TextEditingController();
	int amount = 1;

	return InkWell(
		enableFeedback: false,
		highlightColor: Colors.transparent,
		splashColor: Colors.transparent,
		onTap: () {
			FocusScope.of(context).unfocus();
		},
		  child: Container(
			height: MediaQuery.sizeOf(context).height * 0.7,
			padding: const EdgeInsets.all(14.0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							'Título do item',
							style: TextStyle(
								fontSize: 14,
								fontWeight: FontWeight.w500
							)
						),
						const SizedBox(height: 8),
						Flexible(
							child: TextFormField(
								controller: textTitleController,
								textAlign: TextAlign.start,
								textCapitalization: TextCapitalization.sentences,
								maxLines: 2,
								minLines: 1,
								decoration: ThemeUtils.defaultInputTheme()
							)
						),
						const SizedBox(height: 28),
						Row(
						  children: [
							AmountStepper(
								onDecrease: (value) {
									amount = value;
								}, 
								onIncrease: (value) {
									amount = value;
								}
							),
							Spacer()
						  ],
						),
						const SizedBox(height: 28),
						TextButton(
							style: TextButton.styleFrom(
									backgroundColor: Colors.green,
									foregroundColor: Colors.white
								),
								onPressed: () {
									widget.model.addItem(
										title: textTitleController.text,
										amount: amount
									).whenComplete(
										() {
											Navigator.pop(context);
										}
									);
								}, 
								child: SizedBox(
									width: MediaQuery.sizeOf(context).width,
									child: Text(
										'Adicionar item',
										textAlign: TextAlign.center,
										style: TextStyle(
											fontSize: 16,
											fontWeight: FontWeight.bold
									)
								)
							)
						)
					]
				),
			),
		);
	}
}