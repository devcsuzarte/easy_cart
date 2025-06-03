import 'package:flutter/material.dart';
import 'package:easy_cart/constants.dart';

class AmountStepper extends StatelessWidget {
  const AmountStepper({
    super.key,
    required this.addPressed,
    required this.minusPressed,
    required this.amount,
  });

  final VoidCallback addPressed;
  final VoidCallback minusPressed;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          offset: const Offset(2, 3),
        )],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: IconButton(
              onPressed: addPressed,
              icon: kStepperAddIcon,
            ),
          ),
          Text('${amount}x',
              style: kBodyTextStyle
          ),
          IconButton(
            onPressed: minusPressed,
            icon: kStepperMinusIcon,
          ),
        ],
      ),
    );
  }
}