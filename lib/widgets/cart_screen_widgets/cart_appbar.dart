import 'package:flutter/material.dart';
import 'package:easy_cart/controller/product_data_manager.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/constants.dart';
import 'package:easy_cart/widgets/cart_screen_widgets/delete_alert_dialog.dart';
import 'dart:io' show Platform;


class CartAppbar extends StatelessWidget {
  const CartAppbar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: kAppBarBorderRadius,
        boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          offset: const Offset(0, 2),
        )],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0, bottom: 20.0, right: 25.0, left: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(0, 3),
                    )],
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        kCartIcon,
                        const SizedBox(width: 10,),
                        Text(
                          'R\$${Provider.of<ProductData>(context, listen: true).totalCartPrice.toStringAsFixed(2)}',
                          style: kTitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            RawMaterialButton(
              constraints: kDeleteItemsConstrains,
              shape: const CircleBorder(),
              fillColor: kLightColor,
              onPressed: () => Platform.isIOS ? cupertinoDialog(context) : materialDialog(context),
              child: kDeleteItemsIcon,
            ),
          ],
        ),
      ),
    );
  }
}
