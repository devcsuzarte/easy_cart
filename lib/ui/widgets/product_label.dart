import 'package:flutter/material.dart';
import 'package:easy_cart/core/constants.dart';

class ProductLabel extends StatelessWidget {
  const ProductLabel({
    super.key,
    required this.textLabelController,
    required this.onPressed,
  });

  final TextEditingController textLabelController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        constraints: kProductScanLabelConstrains,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            offset: const Offset(1, 3),
          )],
          color: kProductLabelColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: onPressed,
                  icon: kRefreshIcon,
                ),
              ),
              Expanded(
                flex: 4,
                child: TextField(
                    maxLines: null,
                    textAlign: TextAlign.center,
                    controller: textLabelController,
                    style: kProductLabelTextFieldStyle,
                    decoration: kProductLabelTextFieldDecoration
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}