import 'dart:io';

/// Ponto único de verdade para os IDs do AdMob.
///
/// TODO(user): substituir os placeholders `ca-app-pub-XXXX...` pelos IDs reais
/// do AdMob antes de publicar. Os App IDs também precisam ir no
/// AndroidManifest.xml e no Info.plist (ver plano §7).
class AdConfig {

	// ==== Banner ====
	static String get bannerUnitId => Platform.isAndroid
		? 'ca-app-pub-5891158027265681/6464744648'  // TODO: banner Android real
		: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: banner iOS real

	// ==== Rewarded ====
	static String get rewardedUnitId => Platform.isAndroid
		? 'ca-app-pub-5891158027265681/7359978200'  // TODO: rewarded Android real
		: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: rewarded iOS real

	// IDs de teste oficiais do Google — usar durante o desenvolvimento
	// trocando os getters acima temporariamente:
	//   banner   android: ca-app-pub-3940256099942544/6300978111
	//   banner   ios:     ca-app-pub-3940256099942544/2934735716
	//   rewarded android: ca-app-pub-3940256099942544/5224354917
	//   rewarded ios:     ca-app-pub-3940256099942544/1712485313

	/// Dispara o anúncio recompensado a cada N produtos adicionados ao carrinho.
	static const int rewardedEveryNItems = 10;
}
