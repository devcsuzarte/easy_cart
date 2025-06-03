import 'package:easy_cart/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/controller/product_data_manager.dart';
import 'product_cell.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductData>(
        builder: (context, productData, child) {
          return ListView.separated(
            itemBuilder: (context, index) {
                final product = productData.products[index];
                return Dismissible(
                  key: Key(product.id!.toString()),
                  onDismissed: (direction) {
                    Provider.of<ProductData>(context, listen: false).deleteProduct(product.id!);
                  },
                  background: Container(
                    color: kDestructiveColor, // Background color when swiped
                    child: kDeleteActionIcon, // Icon to indicate delete action
                  ),
                  child: ProductCell(
                      label: product.labelTitle!,
                      amount: product.amount!,
                      price: product.labelPrice!
                  ),
                );
              },
            separatorBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Divider(),
              );
            },
            itemCount: Provider.of<ProductData>(context, listen: false).products.length,
          );
        }
    );
  }
}
