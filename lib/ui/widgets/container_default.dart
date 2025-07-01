import 'package:flutter/material.dart';

class ContainerDefault extends StatelessWidget {

  	const ContainerDefault({
		required this.child,
		super.key
	});

  final Widget child;

  	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(15),
				boxShadow: [
					BoxShadow(
						color: Colors.black12,
						offset: Offset(0, 0),
						blurRadius: 14,
						spreadRadius: -3,
					)
				]
			),
			child: child
		);
	}
}