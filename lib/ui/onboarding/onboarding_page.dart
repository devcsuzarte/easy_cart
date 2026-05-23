import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/sizing.dart';
import 'package:easy_cart/core/style.dart';
import 'package:easy_cart/ui/onboarding/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class OnboardingPage extends StatefulWidget {
	const OnboardingPage({super.key});

	@override
	State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

	final PageController _ctrl = PageController();
	int _currentPage  = 0;
	int _selectedBudget = 300;
	bool _notify80    = true;

	static const _budgetPresets = [100, 200, 300, 500, 750, 1000];

	void _goNext(OnboardingViewmodel model) {
		if (_currentPage < 2) {
			_ctrl.nextPage(
				duration: const Duration(milliseconds: 300),
				curve: Curves.easeInOut,
			);
		} else {
			_finish(model);
		}
	}

	void _skip(OnboardingViewmodel model) {
		_ctrl.animateToPage(
			2,
			duration: const Duration(milliseconds: 400),
			curve: Curves.easeInOut,
		);
	}

	Future<void> _finish(OnboardingViewmodel model) async {
		await model.completeOnboarding();
		if (mounted) {
			Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
		}
	}

	@override
	void dispose() {
		_ctrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<OnboardingViewmodel>.reactive(
			viewModelBuilder: () => OnboardingViewmodel(),
			onViewModelReady: (model) {
				model.selectedBudget.onChange.listen(
					(e) => _selectedBudget = e.neu,
				);
				model.notify80.onChange.listen(
					(e) => _notify80 = e.neu,
				);
			},
			builder: (context, model, widget) {
				return Scaffold(
					backgroundColor: kBgColor,
					body: SafeArea(
						child: Column(
							children: [

								// ── Barra de navegação topo (voltar / pular) ──────
								Padding(
									padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											_currentPage > 0
												? IconButton(
													icon: const Icon(Icons.arrow_back_ios_new, size: 18),
													color: kMutedColor,
													onPressed: () => _ctrl.previousPage(
														duration: const Duration(milliseconds: 300),
														curve: Curves.easeInOut,
													),
												)
												: const SizedBox(width: 48),
											if (_currentPage < 2)
												TextButton(
													onPressed: () => _skip(model),
													child: Text(
														'Pular',
														style: TypographyStyle.body().copyWith(color: kMutedColor),
													),
												),
										],
									),
								),

								// ── PageView ──────────────────────────────────────
								Expanded(
									child: PageView(
										controller: _ctrl,
										onPageChanged: (i) => setState(() => _currentPage = i),
										children: [
											_WelcomePage(onNext: () => _goNext(model)),
											_HowPage(onNext: () => _goNext(model)),
											_BudgetPage(
												selectedBudget: _selectedBudget,
												notify80: _notify80,
												presets: _budgetPresets,
												onSelectBudget: model.selectBudget,
												onToggleNotify80: model.toggleNotify80,
												onFinish: () => _finish(model),
											),
										],
									),
								),

								// ── Indicador de pontos ───────────────────────────
								Padding(
									padding: const EdgeInsets.symmetric(vertical: 24),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: List.generate(3, (i) => AnimatedContainer(
											duration: const Duration(milliseconds: 250),
											margin: const EdgeInsets.symmetric(horizontal: 4),
											width: _currentPage == i ? 20 : 6,
											height: 6,
											decoration: BoxDecoration(
												color: _currentPage == i ? kAccentColor : kMuted2Color,
												borderRadius: BorderRadius.circular(AppRadius.pill),
											),
										)),
									),
								),

							],
						),
					),
				);
			},
		);
	}
}

// ─── Tela 0 — Boas-vindas ────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
	const _WelcomePage({required this.onNext});
	final VoidCallback onNext;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 24),
			child: Column(
				children: [

					// Ilustração tiles flutuantes
					const Expanded(
						child: Center(child: _FloatingTiles()),
					),

					// Título
					Text(
						'Saiba o total\nantes do caixa.',
						style: TypographyStyle.h1().copyWith(height: 1.2),
					),
					const SizedBox(height: 12),

					// Subtítulo
					Text(
						'Tire foto da etiqueta enquanto compra. A gente soma — você anda tranquilo.',
						style: TypographyStyle.body().copyWith(color: kInk2Color),
					),
					const SizedBox(height: 32),

					// Botão "Começar"
					SizedBox(
						width: double.infinity,
						child: ElevatedButton(
							onPressed: onNext,
							style: ElevatedButton.styleFrom(
								backgroundColor: kAccentColor,
								foregroundColor: Colors.white,
								elevation: 0,
								padding: const EdgeInsets.symmetric(vertical: 14),
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(AppRadius.md),
								),
							),
							child: Text(
								'Começar',
								style: TypographyStyle.bodyEmph().copyWith(color: Colors.white),
							),
						),
					),
					const SizedBox(height: 10),

					// Link "Já tenho conta"
					TextButton(
						onPressed: onNext,
						child: Text(
							'Já tenho conta',
							style: TypographyStyle.body().copyWith(color: kMutedColor),
						),
					),
					const SizedBox(height: 8),

				],
			),
		);
	}
}

/// Colagem de tiles flutuantes usada na tela de boas-vindas.
class _FloatingTiles extends StatelessWidget {
	const _FloatingTiles();

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			width: 260,
			height: 220,
			child: Stack(
				children: [

					// Tile traseiro esquerdo — receipt (kAccentSoftColor)
					Positioned(
						top: 10, left: 10,
						child: Transform.rotate(
							angle: -0.14,
							child: Container(
								width: 120, height: 82,
								decoration: BoxDecoration(
									color: kAccentSoftColor,
									borderRadius: BorderRadius.circular(AppRadius.lg),
									boxShadow: AppShadow.md,
								),
								child: const Center(
									child: Icon(Icons.receipt_long_outlined, color: kAccentColor, size: 36),
								),
							),
						),
					),

					// Tile traseiro direito — check (kGreenTintColor)
					Positioned(
						top: 18, right: 8,
						child: Transform.rotate(
							angle: 0.10,
							child: Container(
								width: 88, height: 70,
								decoration: BoxDecoration(
									color: kGreenTintColor,
									borderRadius: BorderRadius.circular(AppRadius.lg),
									boxShadow: AppShadow.sm,
								),
								child: const Center(
									child: Icon(Icons.check_circle_outline, color: kGreenColor, size: 28),
								),
							),
						),
					),

					// Tile central — carrinho (kSurfaceColor com sombra grande)
					Positioned(
						top: 58, left: 68,
						child: Container(
							width: 124, height: 112,
							decoration: BoxDecoration(
								color: kSurfaceColor,
								borderRadius: BorderRadius.circular(AppRadius.xl),
								boxShadow: AppShadow.lg,
								border: Border.all(color: kHairlineColor),
							),
							child: const Center(
								child: Icon(Icons.shopping_cart_outlined, color: kAccentColor, size: 46),
							),
						),
					),

					// Círculo menor inferior direito — câmera (kAccentColor)
					Positioned(
						bottom: 12, right: 28,
						child: Container(
							width: 50, height: 50,
							decoration: const BoxDecoration(
								color: kAccentColor,
								shape: BoxShape.circle,
								boxShadow: AppShadow.sm,
							),
							child: const Center(
								child: Icon(Icons.photo_camera_outlined, color: Colors.white, size: 22),
							),
						),
					),

				],
			),
		);
	}
}

// ─── Tela 1 — Como funciona ──────────────────────────────────────────────────

class _HowPage extends StatelessWidget {
	const _HowPage({required this.onNext});
	final VoidCallback onNext;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 24),
			child: Column(
				children: [

					// Ilustração: mockup de celular com viewfinder
					const Expanded(
						child: Center(child: _PhoneMockup()),
					),

					// Título
					Text(
						'Tire foto da etiqueta —\na gente faz o resto.',
						style: TypographyStyle.h1().copyWith(height: 1.2),
					),
					const SizedBox(height: 12),

					// Subtítulo
					Text(
						'O app lê nome e preço automaticamente. Sem digitar.',
						style: TypographyStyle.body().copyWith(color: kInk2Color),
					),
					const SizedBox(height: 32),

					// Botão "Próximo"
					SizedBox(
						width: double.infinity,
						child: ElevatedButton(
							onPressed: onNext,
							style: ElevatedButton.styleFrom(
								backgroundColor: kAccentColor,
								foregroundColor: Colors.white,
								elevation: 0,
								padding: const EdgeInsets.symmetric(vertical: 14),
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(AppRadius.md),
								),
							),
							child: Text(
								'Próximo',
								style: TypographyStyle.bodyEmph().copyWith(color: Colors.white),
							),
						),
					),
					const SizedBox(height: 8),

				],
			),
		);
	}
}

/// Mockup de celular com viewfinder OCR simulado.
class _PhoneMockup extends StatelessWidget {
	const _PhoneMockup();

	@override
	Widget build(BuildContext context) {
		return Container(
			width: 170,
			height: 234,
			decoration: BoxDecoration(
				color: kInkColor,
				borderRadius: BorderRadius.circular(28),
				boxShadow: AppShadow.lg,
			),
			padding: const EdgeInsets.all(10),
			child: Column(
				children: [

					// Dynamic island / notch
					Container(
						width: 44, height: 6,
						decoration: BoxDecoration(
							color: kInk2Color,
							borderRadius: BorderRadius.circular(3),
						),
					),
					const SizedBox(height: 6),

					// Área do viewfinder
					Expanded(
						child: Container(
							decoration: BoxDecoration(
								color: const Color(0xFF1E1A14),
								borderRadius: BorderRadius.circular(16),
							),
							child: Stack(
								children: [

									// Cantos do viewfinder
									const Positioned(top: 12, left: 12, child: _CornerBracket()),
									const Positioned(top: 12, right: 12, child: _CornerBracket(flipH: true)),
									const Positioned(bottom: 12, left: 12, child: _CornerBracket(flipV: true)),
									const Positioned(bottom: 12, right: 12, child: _CornerBracket(flipH: true, flipV: true)),

									// Card de produto detectado
									Center(
										child: Container(
											padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
											decoration: BoxDecoration(
												color: kSurfaceColor.withAlpha(230),
												borderRadius: BorderRadius.circular(AppRadius.sm),
											),
											child: Column(
												mainAxisSize: MainAxisSize.min,
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Text(
														'Arroz Branco 5kg',
														style: TypographyStyle.labelXs().copyWith(
															color: kInkColor,
															fontSize: 9,
														),
													),
													Text(
														'R\$ 12,90',
														style: TypographyStyle.mono(size: 11).copyWith(
															color: kAccentColor,
														),
													),
												],
											),
										),
									),

								],
							),
						),
					),
					const SizedBox(height: 8),

					// Botão shutter
					Container(
						width: 42, height: 42,
						decoration: BoxDecoration(
							color: Colors.white,
							shape: BoxShape.circle,
							border: Border.all(color: kMuted2Color, width: 3),
						),
					),
					const SizedBox(height: 4),

				],
			),
		);
	}
}

/// Canto em L usado no viewfinder do mockup.
class _CornerBracket extends StatelessWidget {
	const _CornerBracket({this.flipH = false, this.flipV = false});
	final bool flipH;
	final bool flipV;

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			width: 14, height: 14,
			child: Stack(
				children: [
					// Barra horizontal
					Positioned(
						top:    flipV ? null : 0,
						bottom: flipV ? 0    : null,
						left: 0, right: 0,
						child: Container(height: 2, color: kAccentColor),
					),
					// Barra vertical
					Positioned(
						left:  flipH ? null : 0,
						right: flipH ? 0    : null,
						top: 0, bottom: 0,
						child: Container(width: 2, color: kAccentColor),
					),
				],
			),
		);
	}
}

// ─── Tela 2 — Orçamento ──────────────────────────────────────────────────────

class _BudgetPage extends StatelessWidget {
	const _BudgetPage({
		required this.selectedBudget,
		required this.notify80,
		required this.presets,
		required this.onSelectBudget,
		required this.onToggleNotify80,
		required this.onFinish,
	});

	final int selectedBudget;
	final bool notify80;
	final List<int> presets;
	final void Function(int) onSelectBudget;
	final void Function(bool) onToggleNotify80;
	final VoidCallback onFinish;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 24),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [

					const SizedBox(height: 8),

					// Título
					Text(
						'Defina um\norçamento.',
						style: TypographyStyle.h1().copyWith(height: 1.2),
					),
					const SizedBox(height: 10),

					// Subtítulo
					Text(
						'Avisamos quando você se aproxima do limite. Você pode mudar a qualquer momento.',
						style: TypographyStyle.body().copyWith(color: kInk2Color),
					),
					const SizedBox(height: 28),

					// Label "Orçamento semanal"
					Text('Orçamento semanal', style: TypographyStyle.labelXs()),
					const SizedBox(height: 12),

					// Chips de presets
					Wrap(
						spacing: 8,
						runSpacing: 8,
						children: presets.map((v) {
							final isSelected = v == selectedBudget;
							return GestureDetector(
								onTap: () => onSelectBudget(v),
								child: AnimatedContainer(
									duration: const Duration(milliseconds: 200),
									padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
									decoration: BoxDecoration(
										color: isSelected ? kAccentColor : kSurfaceColor,
										borderRadius: BorderRadius.circular(AppRadius.pill),
										border: Border.all(
											color: isSelected ? kAccentColor : kHairline2Color,
										),
										boxShadow: isSelected ? AppShadow.sm : null,
									),
									child: Text(
										'R\$ $v',
										style: TypographyStyle.bodyEmph().copyWith(
											color: isSelected ? Colors.white : kInk2Color,
										),
									),
								),
							);
						}).toList(),
					),
					const SizedBox(height: 28),

					// Toggle "Avisar ao chegar em 80%"
					Container(
						padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
						decoration: BoxDecoration(
							color: kSurfaceColor,
							borderRadius: BorderRadius.circular(AppRadius.md),
							border: Border.all(color: kHairlineColor),
						),
						child: Row(
							children: [
								Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text('Avisar ao chegar em 80%', style: TypographyStyle.bodyEmph()),
											const SizedBox(height: 2),
											Text(
												'Receba um alerta quando estiver perto do limite',
												style: TypographyStyle.labelXs(),
											),
										],
									),
								),
								Switch(
									value: notify80,
									onChanged: onToggleNotify80,
									activeThumbColor: kAccentColor,
									activeTrackColor: kAccentSoftColor,
								),
							],
						),
					),

					const Spacer(),

					// Botão "Tudo pronto"
					SizedBox(
						width: double.infinity,
						child: ElevatedButton(
							onPressed: onFinish,
							style: ElevatedButton.styleFrom(
								backgroundColor: kAccentColor,
								foregroundColor: Colors.white,
								elevation: 0,
								padding: const EdgeInsets.symmetric(vertical: 14),
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(AppRadius.md),
								),
							),
							child: Text(
								'Tudo pronto',
								style: TypographyStyle.bodyEmph().copyWith(color: Colors.white),
							),
						),
					),
					const SizedBox(height: 8),

				],
			),
		);
	}
}
