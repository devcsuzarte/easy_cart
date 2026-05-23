// ignore_for_file: must_be_immutable

import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
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
	final TextEditingController textTitleController = TextEditingController();
	int amount = 1;

	@override
	Widget build(BuildContext context) {

		void dismiss() => Navigator.pop(context);

		return InkWell(
			highlightColor: Colors.transparent,
			splashColor: Colors.transparent,
			onTap: () { FocusScope.of(context).unfocus(); },
			child: Container(
				height: MediaQuery.sizeOf(context).height * 0.7,
				padding: const EdgeInsets.all(18.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						// Título
						Text('Novo item', style: TypographyStyle.h2()),
						const SizedBox(height: 16),

						// Campo nome
						TextFormField(
							controller: textTitleController,
							textAlign: TextAlign.start,
							textCapitalization: TextCapitalization.sentences,
							maxLines: 2,
							minLines: 1,
							decoration: ThemeUtils.defaultInputTheme(),
						),
						const SizedBox(height: 24),

						// Stepper quantidade
						Row(
							children: [
								AmountStepper(
									onDecrease: (value) { amount = value; },
									onIncrease: (value) { amount = value; },
								),
								const Spacer(),
							],
						),
						const SizedBox(height: 28),

						// Botão "Adicionar item"
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
									widget.model.addItem(
										title: textTitleController.text,
										amount: amount,
									).whenComplete(() { dismiss(); });
								},
								child: Text(
									'Adicionar item',
									style: TypographyStyle.bodyEmph().copyWith(color: Colors.white),
								),
							),
						),
					],
				),
			),
		);
	}
}
