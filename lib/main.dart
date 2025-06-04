import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'ui/pages/cart/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/controller/product_data_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: CupertinoColors.systemGreen),
          useMaterial3: true,
        ),
        home: CartScreen(),
      ),
    );
  }
}