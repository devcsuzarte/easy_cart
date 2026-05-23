import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/managers/list_manager.dart';
import 'package:easy_cart/ui/cart/cart_page.dart';
import 'package:easy_cart/ui/history/history_page.dart';
import 'package:easy_cart/ui/list/list_page.dart';
import 'package:easy_cart/ui/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cart/core/database/database_repository.dart';
import 'package:easy_cart/utils/scanner.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	final prefs = await SharedPreferences.getInstance();
	final onboardingDone = prefs.getBool('onboarding_done') ?? false;
	runApp(MyApp(initialRoute: onboardingDone ? '/' : '/onboarding'));
}

ThemeData _buildTheme(Brightness brightness) {
	final isDark = brightness == Brightness.dark;
	return ThemeData(
		colorScheme: ColorScheme.fromSeed(
			seedColor: kAccentColor,
			brightness: brightness,
		),
		textTheme: GoogleFonts.plusJakartaSansTextTheme(
			ThemeData(brightness: brightness).textTheme,
		),
		scaffoldBackgroundColor: isDark ? const Color(0xFF14110D) : kBgColor,
		useMaterial3: true,
	);
}

class MyApp extends StatelessWidget {
	const MyApp({super.key, required this.initialRoute});

	final String initialRoute;

	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				Provider(
					create: (context) => DatabaseManager()
				),
				Provider(
					create: (context) => Scanner()
				),
				Provider(
					create: (context) => ProductManager()
				),
				Provider(
					create: (context) => ListManager()
				)
			],
			child: MaterialApp(
				debugShowCheckedModeBanner: false,
				initialRoute: initialRoute,
				routes: {
					'/':            (context) => const CartPage(),
					'/list':        (context) => const ListPage(),
					'/history':     (context) => const HistoryPage(),
					'/onboarding':  (context) => const OnboardingPage(),
				},
				title: 'Carrinho Fácil',
				themeMode: ThemeMode.system,
				theme: _buildTheme(Brightness.light),
				darkTheme: _buildTheme(Brightness.dark),
			)
		);
	}
}
