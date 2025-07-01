import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/ui/cart/cart_page.dart';
import 'package:easy_cart/ui/scan/scan_screen.dart';
import 'package:easy_cart/ui/shop_list/list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	  int _selectedIndex = 0;

	void _onTapped(int index){
		setState(() {
		_selectedIndex = index;
		});
	}

	final List<Widget> _pages = [
		CartPage(),
		ShopListPage(),
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: _pages[_selectedIndex],
			floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
			floatingActionButton: FloatingActionButton(
				backgroundColor: Colors.green,
				onPressed: () {
					showModalBottomSheet(
						context: context,
						showDragHandle: true,
						backgroundColor: Colors.white,
						builder: (context) => ScanScreen()
					);
				},
				tooltip: "Run action",
				child: Icon(
					_selectedIndex != 0 ? 
						Icons.add : 
						CupertinoIcons.barcode_viewfinder,
					color: Colors.white,
					size: 40,
				)
			),
			bottomNavigationBar: BottomNavigationBar(
				currentIndex: _selectedIndex,
				onTap: _onTapped,
				items: [
					BottomNavigationBarItem(
						label: 'Meu carrinho',
						icon: Icon(
							Icons.shopping_cart,
						)
					),
					BottomNavigationBarItem(
						label: 'Minha Lista',
						icon: Icon(
							Icons.list
						)
					)
				]
			)
		);
	}
}