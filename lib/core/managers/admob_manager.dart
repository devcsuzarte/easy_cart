import 'package:easy_cart/core/ads/ad_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Manager do AdMob — segue o padrão dos demais managers (registrado no
/// MultiProvider). Cuida da inicialização do SDK, do anúncio recompensado
/// (pré-carregado e servido a cada N itens) e da contagem de itens.
///
/// O contador vive em memória → reinicia a cada abertura do app (por sessão).
class AdMobManager {

	RewardedAd? _rewarded;
	bool _isLoadingRewarded = false;
	int _itemCount = 0;

	Future<void> initialize() async {
		await MobileAds.instance.initialize();
		_loadRewarded();
	}

	/// Chamado sempre que um produto é adicionado ao carrinho com sucesso.
	/// Cada produto conta como 1, independente da quantidade.
	void registerCartItemAdded() {
		_itemCount++;
		if (_itemCount % AdConfig.rewardedEveryNItems == 0) {
			_showRewarded();
		}
	}

	void _loadRewarded() {
		if (_isLoadingRewarded || _rewarded != null) return;
		_isLoadingRewarded = true;
		RewardedAd.load(
			adUnitId: AdConfig.rewardedUnitId,
			request: const AdRequest(),
			rewardedAdLoadCallback: RewardedAdLoadCallback(
				onAdLoaded: (ad) {
					_rewarded = ad;
					_isLoadingRewarded = false;
				},
				onAdFailedToLoad: (error) {
					_rewarded = null;
					_isLoadingRewarded = false;
				},
			),
		);
	}

	void _showRewarded() {
		final ad = _rewarded;
		if (ad == null) {
			// Ainda não carregou — prepara para o próximo ciclo e segue o fluxo.
			_loadRewarded();
			return;
		}

		ad.fullScreenContentCallback = FullScreenContentCallback(
			onAdDismissedFullScreenContent: (ad) {
				ad.dispose();
				_rewarded = null;
				_loadRewarded();
			},
			onAdFailedToShowFullScreenContent: (ad, error) {
				ad.dispose();
				_rewarded = null;
				_loadRewarded();
			},
		);

		_rewarded = null;
		ad.show(onUserEarnedReward: (ad, reward) {});
	}
}
