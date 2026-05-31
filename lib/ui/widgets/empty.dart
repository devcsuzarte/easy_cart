import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Empty extends StatelessWidget {
	const Empty({
		super.key,
		required this.imgUrl,
		required this.title,
		this.subtitle,
	});

	final String imgUrl, title;
	final String? subtitle;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.all(30),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						width: 132,
						height: 132,
						decoration: BoxDecoration(
							gradient: const LinearGradient(
								begin: Alignment.topLeft,
								end: Alignment.bottomRight,
								colors: [kAccentTintColor, kSurface3Color],
							),
							borderRadius: BorderRadius.circular(AppRadius.xl),
							boxShadow: AppShadow.md,
						),
						child: ClipRRect(
							borderRadius: BorderRadius.circular(AppRadius.xl),
							child: Padding(
								padding: const EdgeInsets.all(24),
								child: SvgPicture.asset(
									imgUrl
								),
							),
						),
					),
					const SizedBox(height: 22),
					Text(
						title,
						textAlign: TextAlign.center,
						style: TypographyStyle.h1(),
					),
					if (subtitle != null) ...[
						const SizedBox(height: 8),
						Text(
							subtitle!,
							textAlign: TextAlign.center,
							style: TypographyStyle.body().copyWith(color: kMutedColor),
						),
					],
				],
			),
		);
	}
}
