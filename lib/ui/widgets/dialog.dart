import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/core/constants.dart';

class DefaultDialog {
	final BuildContext context;
	final Function defaultFunction;
	final String title,  
		message,
		buttonTitle;
	final Function? alternativeFunction;
	final String? altFunctionMessage;
	final bool primaryButtonDestructive, 
		altButtonDestructive;

	DefaultDialog({
		required this.context, 
		required this.defaultFunction,
		required this.title, 
		required this.message,
		required this.buttonTitle,
		this.alternativeFunction,
		this.altFunctionMessage,
		this.primaryButtonDestructive = false,
		this.altButtonDestructive = false
	});

	void showDefaultDialog(){
		if(Platform.isIOS){
			_buildCupertinoDialog();
			return;
		}
		_buildMaterialDialog(context);
	}

	void _buildCupertinoDialog(){
		showCupertinoDialog<void>(
			context: context,
			builder: (BuildContext context) => CupertinoAlertDialog(
				title: Text(title),
				content: Text(message),
				actions: <CupertinoDialogAction> [
					if(altFunctionMessage != null)
					CupertinoDialogAction(
						isDefaultAction: altButtonDestructive,
						child: Text(
							altFunctionMessage!,
							style: TextStyle(
								color: Colors.blue
							),
						),
						onPressed: () {
							if(alternativeFunction != null){
								alternativeFunction!();
							}
							Navigator.pop(context);
						}
					),
					
					CupertinoDialogAction(
						isDestructiveAction: primaryButtonDestructive,
						child: Text(buttonTitle),
						onPressed: () => defaultFunction(),
					)
				]
			)
		);
	}

  Future<void> _buildMaterialDialog(BuildContext context) async {
		return showDialog<void>(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text(title),
					content: Text(message),
					actions: [
						TextButton(
						onPressed: () => defaultFunction(),
							child: Text(
									buttonTitle,
									style: TextStyle(
											color: Colors.red
									)
							),
						),
						TextButton(
							onPressed: () {
								if(alternativeFunction != null){
									alternativeFunction!();
								}
							},
							child: Text(
								altFunctionMessage!,
								style: TextStyle(
										color: Colors.blue
								),
							),
						)
					]
				);
			}
		);
	}
}
