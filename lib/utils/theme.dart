import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:flutter/material.dart';

class ThemeUtils {
	static InputDecoration defaultInputTheme() => InputDecoration(
		filled: true,
		fillColor: kSurfaceColor,
		hintText: 'Ex: Arroz Branco',
		hintStyle: TypographyStyle.body().copyWith(color: kMutedColor),
		contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
		border: _border(),
		enabledBorder: _border(),
		focusedBorder: _border(isFocus: true),
	);

	static OutlineInputBorder _border({bool isFocus = false}) => OutlineInputBorder(
		borderSide: BorderSide(
			color: isFocus ? kAccentColor : kHairline2Color,
			width: isFocus ? 2.0 : 1.0,
		),
		borderRadius: BorderRadius.circular(AppRadius.md),
	);
}
