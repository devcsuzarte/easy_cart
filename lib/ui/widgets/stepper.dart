import 'package:flutter/material.dart';

class AmountStepper extends StatefulWidget {
  const AmountStepper({
	required this.onDecrease,
	required this.onIncrease,
	super.key
});

  final Function(int) onIncrease, onDecrease;

  @override
  State<AmountStepper> createState() => _AmountStepperState();
}

class _AmountStepperState extends State<AmountStepper> {
	int value = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
		padding: const EdgeInsets.all(5),
		decoration: BoxDecoration(
			color: Color(0xFFF8F9FA),
			borderRadius: BorderRadius.circular(50)
		),
		child: Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				GestureDetector(
					onTap: (){
						if(value > 1){
							setState(() {
							 	value--;
								widget.onDecrease(value);
							});
						}
					},
					child: Container(
						padding: const EdgeInsets.all(8),
						decoration: BoxDecoration(
							color: Colors.white,
							shape: BoxShape.circle,
							border:  Border.all(
								color: Color(0xFFDEE2E6)
							)
						),
						child: Icon(
							Icons.remove,
							color: Colors.black,
							size: 30
						)
					)
				),
				const SizedBox(width: 18),
				Text(
					'${value}x',
					style: TextStyle(
						fontSize: 30,
						fontWeight: FontWeight.bold
					),
				),
				const SizedBox(width: 18),
				GestureDetector(
					onTap: (){
						setState(() {
						  	value++;
							widget.onIncrease(value);
						});
					},
					child: Container(
						padding: const EdgeInsets.all(8),
						decoration: BoxDecoration(
							color: Colors.white,
							shape: BoxShape.circle,
							border: Border.all(
								color: Color(0xFFDEE2E6)
							)
						),
						child: Icon(
							Icons.add,
							color: Colors.black,
							size: 30
						)
					)
				)
			]
		)
	);
  }
}