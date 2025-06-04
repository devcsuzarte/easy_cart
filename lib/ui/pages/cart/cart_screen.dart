import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/ui/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_cart/controller/product_data_manager.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/ui/widgets/cart_appbar.dart';
import 'package:easy_cart/controller/scan_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductData>(context, listen: false).showData();
  }
  Widget build(BuildContext context) {
    var scanManager = ScanManager(context: context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanManager.scanLabel();
        },
        tooltip: "Ler etiqueta",
        child: kFloatingActionIcon
      ),
      appBar: PreferredSize(
          preferredSize: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.18),
          child: CartAppbar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ProductsList(),
      )
    );
  }
}