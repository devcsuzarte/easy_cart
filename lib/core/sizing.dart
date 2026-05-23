import 'package:flutter/material.dart';

class AppRadius {
	static const sm   = 10.0;
	static const md   = 16.0;
	static const lg   = 22.0;
	static const xl   = 28.0;
	static const pill = 999.0;
}

class AppShadow {
	static const sm = [
		BoxShadow(color: Color(0x0D1B1814), offset: Offset(0, 1), blurRadius: 2),
		BoxShadow(color: Color(0x0A1B1814), offset: Offset(0, 1), blurRadius: 1),
	];
	static const md = [
		BoxShadow(color: Color(0x0F1B1814), offset: Offset(0, 4), blurRadius: 14),
		BoxShadow(color: Color(0x0D1B1814), offset: Offset(0, 1), blurRadius: 2),
	];
	static const lg = [
		BoxShadow(color: Color(0x1A1B1814), offset: Offset(0, 18), blurRadius: 38),
		BoxShadow(color: Color(0x0F1B1814), offset: Offset(0, 4), blurRadius: 10),
	];
}
