import 'package:easy_cart/core/sizing.dart';
import 'package:flutter/material.dart';

class ContainerDefault extends StatelessWidget {

	const ContainerDefault({
		required this.child,
		this.onPress,
		this.onHold,
		super.key
	});

	final Widget child;
	final Function? onPress, onHold;

	@override
	Widget build(BuildContext context) {
		final surface = Theme.of(context).colorScheme.surface;
		return GestureDetector(
			onTap: () { if (onPress != null) onPress!(); },
			onLongPress: () { if (onHold != null) onHold!(); },
			child: Container(
				padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
				decoration: BoxDecoration(
					color: surface,
					borderRadius: BorderRadius.circular(AppRadius.md),
					boxShadow: AppShadow.sm,
				),
				child: child,
			),
		);
	}
}
