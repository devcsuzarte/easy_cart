import 'package:easy_cart/core/ads/ad_config.dart';
import 'package:easy_cart/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Banner fixo reutilizável. Cada tela cria a sua própria instância — o banner
/// vive e morre junto da tela. Enquanto não carrega, não ocupa espaço.
class AdBanner extends StatefulWidget {
	const AdBanner({super.key});

	@override
	State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {

	BannerAd? _bannerAd;
	bool _loaded = false;

	@override
	void initState() {
		super.initState();
		_loadBanner();
	}

	void _loadBanner() {
		final banner = BannerAd(
			adUnitId: AdConfig.bannerUnitId,
			size: AdSize.banner,
			request: const AdRequest(),
			listener: BannerAdListener(
				onAdLoaded: (ad) {
					if (!mounted) {
						ad.dispose();
						return;
					}
					setState(() => _loaded = true);
				},
				onAdFailedToLoad: (ad, error) {
					ad.dispose();
				},
			),
		);
		_bannerAd = banner;
		banner.load();
	}

	@override
	void dispose() {
		_bannerAd?.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final ad = _bannerAd;
		if (!_loaded || ad == null) return const SizedBox.shrink();

		return Container(
			color: kSurfaceColor,
			alignment: Alignment.center,
			width: ad.size.width.toDouble(),
			height: ad.size.height.toDouble(),
			child: AdWidget(ad: ad),
		);
	}
}
