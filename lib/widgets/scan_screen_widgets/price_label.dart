import 'dart:ui';
import 'package:easy_cart/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PriceLabel extends StatelessWidget {
  const PriceLabel({
    super.key,
    required this.textPriceController,
    required this.onPressed,
  });

  final TextEditingController textPriceController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          offset: const Offset(1,2),
        )],
      ),
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: onPressed,
              icon: kRefreshIcon,
            ),
          ),
          const Expanded(child: Text(
            'R\$',
            textAlign: TextAlign.end,
            style: kPriceLabelTextStyle,
          ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              style: kLargeTextStyle,
              controller: textPriceController,
              decoration: kPriceTextInputDecoration,
            ),
          )
        ],
      ),
    );
  }
}