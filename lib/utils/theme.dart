import 'package:flutter/material.dart';

class ThemeUtils {
	static InputDecoration defaultInputTheme() => InputDecoration(
		filled: true,
		fillColor: Colors.white,
		hintText: 'Ex: Arroz Branco',
		contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
		border: defaultInputBorder(),
		enabledBorder: defaultInputBorder(),
		focusedBorder: defaultInputBorder(isFocus: true),
	);

	static OutlineInputBorder defaultInputBorder({
		bool isFocus = false
	}) => OutlineInputBorder(
		borderSide:  BorderSide(
			color: Colors.green,
			width: isFocus ? 2.0 : 1.0
		),
		borderRadius: BorderRadius.all(Radius.circular(12.0)),
	);
}