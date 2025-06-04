import 'package:easy_cart/core/constants.dart';
import 'package:flutter/material.dart';

class ProductCell extends StatelessWidget {
  const ProductCell({
    super.key,
    required this.label,
    required this.amount,
    required this.price});

  final String label;
  final int amount;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            child: Text(
              '${amount}x',
              style: kBodyTextStyle,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  label,
                   softWrap: true,
                   style: kBodyTextStyle,
              ),
              Text(
                  'Preço Unidade: R\$$price',
                   style: kPriceCellTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
