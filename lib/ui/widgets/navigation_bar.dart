import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:flutter/material.dart';

class DefaultNavBar extends StatelessWidget {
	const DefaultNavBar({
		super.key,
		required this.selectedIndex,
		required this.onTap,
	});

	final int selectedIndex;
	final void Function(int) onTap;

	static const _labels = ['Carrinho', 'Lista', 'Histórico'];
	static const _icons         = [Icons.shopping_cart,          Icons.list_alt,  Icons.history];
	static const _iconsInactive = [Icons.shopping_cart_outlined, Icons.list_alt,  Icons.history];

	@override
	Widget build(BuildContext context) {
		// Edge-to-edge: respeitar o inset real do sistema (gesto ~24-34px,
		// 3 botões ~48px) em vez de um valor fixo, para a pill não sobrepor
		// a barra de navegação em nenhum device.
		final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
		return Container(
			color: Colors.transparent,
			padding: EdgeInsets.fromLTRB(14, 8, 14, bottomInset > 0 ? bottomInset + 4 : 20),
			child: Container(
				decoration: BoxDecoration(
					color: kSurfaceColor,
					borderRadius: BorderRadius.circular(AppRadius.lg),
					boxShadow: AppShadow.sm,
					border: Border.all(color: kHairlineColor),
				),
				padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: List.generate(_labels.length, (i) {
						final active = i == selectedIndex;
						return GestureDetector(
							onTap: () => onTap(i),
							behavior: HitTestBehavior.opaque,
							child: Padding(
								padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
								child: Column(
									mainAxisSize: MainAxisSize.min,
									children: [
										Icon(
											active ? _icons[i] : _iconsInactive[i],
											color: active ? kInkColor : kMutedColor,
											size: 24,
										),
										const SizedBox(height: 4),
										Text(
											_labels[i],
											style: TypographyStyle.labelXs().copyWith(
												color: active ? kInkColor : kMutedColor,
											),
										),
									],
								),
							),
						);
					}),
				),
			),
		);
	}
}
