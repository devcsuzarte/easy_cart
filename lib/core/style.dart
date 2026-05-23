import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyStyle {

	// Helpers internos — cores hardcoded para evitar dependência circular com constants.dart
	static TextStyle _display({
		double size = 28,
		FontWeight weight = FontWeight.w700,
		double tracking = -0.02,
	}) =>
		GoogleFonts.bricolageGrotesque(
			fontSize: size,
			fontWeight: weight,
			letterSpacing: size * tracking,
			height: 1.05,
		);

	static TextStyle _body({
		double size = 14,
		FontWeight weight = FontWeight.w400,
		Color? color,
	}) =>
		GoogleFonts.plusJakartaSans(
			fontSize: size,
			fontWeight: weight,
			color: color ?? const Color(0xFF1B1814), // kInkColor
		);

	// Métodos existentes (mantidos para não quebrar chamadas atuais)
	static TextStyle title1() => _display(size: 28, weight: FontWeight.w700);

	static TextStyle subTitle() => _body(size: 15, color: const Color(0xFF4F4A42)); // kInk2Color

	// Escala de display
	static TextStyle displayXL() => _display(size: 72, weight: FontWeight.w700, tracking: -0.04);
	static TextStyle displayL()  => _display(size: 56, weight: FontWeight.w700, tracking: -0.04);
	static TextStyle display()   => _display(size: 40, weight: FontWeight.w700, tracking: -0.03);

	// Headings
	static TextStyle h1() => _display(size: 28, weight: FontWeight.w700);
	static TextStyle h2() => _display(size: 22, weight: FontWeight.w600, tracking: -0.01);
	static TextStyle h3() => _display(size: 17, weight: FontWeight.w600, tracking: 0);

	// Corpo
	static TextStyle body()     => _body(size: 14, weight: FontWeight.w400);
	static TextStyle bodyEmph() => _body(size: 14, weight: FontWeight.w600);

	// Label pequeno com tracking
	static TextStyle labelXs() => _body(
		size: 11,
		weight: FontWeight.w600,
		color: const Color(0xFF978E81), // kMutedColor
	).copyWith(letterSpacing: 0.88);

	// Monospace tabulado — usar em todos os preços
	static TextStyle mono({double size = 14}) => GoogleFonts.jetBrainsMono(
		fontSize: size,
		fontWeight: FontWeight.w600,
		fontFeatures: const [FontFeature.tabularFigures()],
	);
}
