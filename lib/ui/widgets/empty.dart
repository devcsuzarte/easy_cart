import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
	const Empty({
		super.key,
		required this.imgUrl,
		required this.title
	});

	final String imgUrl, title;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.all(30),
			child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				Image.asset(imgUrl),
				const SizedBox(height: 15),
				Text(
					title,
					textAlign: TextAlign.center,
					style: TextStyle(
						fontWeight: FontWeight.bold
					),
				)
			],
			),
		);
	}
}