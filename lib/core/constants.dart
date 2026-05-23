import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_cart/core/style.dart';

// TABLE — nomes intocáveis (mapeados no SQLite)
const String kProductTable    = 'productList';
const String kShopListTable   = 'shopList';
const String kCartHistoryTable = 'shopHistory';

// ─── CORES ────────────────────────────────────────────────────────────────────

// Existentes — valores atualizados para a nova paleta
const kProductLabelColor = Color(0xFFFFF203);         // amarelo mantido
const kPrimaryColor      = Color(0xFFE04E25);          // persimmon
const kSecondaryColor    = Color(0xFF2F6F4F);          // green refinado
const kLightColor        = Color(0xFFF4EFE6);          // creme
const kDarkColor         = Color(0xFF1B1814);          // ink
const kDestructiveColor  = Color(0xFFC13F19);          // accent dark

// Novos tokens semânticos
const kBgColor           = Color(0xFFF4EFE6);
const kSurfaceColor      = Color(0xFFFFFFFF);
const kSurface2Color     = Color(0xFFFAF6EE);
const kSurface3Color     = Color(0xFFEFE8D9);
const kInkColor          = Color(0xFF1B1814);
const kInk2Color         = Color(0xFF4F4A42);
const kMutedColor        = Color(0xFF978E81);
const kMuted2Color       = Color(0xFFBFB6A7);
const kHairlineColor     = Color(0x141B1814); // rgba(27,24,20,.08)
const kHairline2Color    = Color(0x241B1814); // rgba(27,24,20,.14)
const kAccentColor       = Color(0xFFE04E25);
const kAccentDarkColor   = Color(0xFFC13F19);
const kAccentSoftColor   = Color(0xFFFCE3D8);
const kAccentTintColor   = Color(0xFFFFF1EA);
const kAccentInkColor    = Color(0xFF6E2310);
const kGreenColor        = Color(0xFF2F6F4F);
const kGreenSoftColor    = Color(0xFFDFEDE0);
const kGreenTintColor    = Color(0xFFECF4ED);
const kWarnColor         = Color(0xFFB97A1C);
const kWarnSoftColor     = Color(0xFFFAE9CB);

// ─── TEXTO — diálogos (mantidos como const Widget) ───────────────────────────
const kDialogTitleText        = Text('Deseja limpar o carrinho?');
const kDialogContentText      = Text('Deseja limpar o carrinho?');
const kDialogActionDefaultText = Text('Sim');
const kDialogActionDismissText = Text('Não');

// ─── TEXT STYLES — final (GoogleFonts não é const) ───────────────────────────
// Nomes preservados; valores apontam para TypographyStyle para manter consistência.
final kBodyTextStyle              = TypographyStyle.body();
final kBodyWhiteTextStyle         = TypographyStyle.body().copyWith(color: Colors.white);
final kLargeTextStyle             = TypographyStyle.display();
final kTitleTextStyle             = TypographyStyle.h1().copyWith(color: kDarkColor);
final kProductLabelTextFieldStyle = TypographyStyle.h2();
final kPriceCellTextStyle         = TypographyStyle.mono(size: 15);
final kPriceLabelTextStyle        = TypographyStyle.displayXL();

// ─── INPUT DECORATIONS (podem permanecer const — não usam GoogleFonts) ────────
const kPriceTextInputDecoration = InputDecoration(
	hintText: '00,00',
	border: InputBorder.none,
);

const kProductLabelTextFieldDecoration = InputDecoration(
	hintText: 'PRODUTO',
	border: InputBorder.none,
);

// ─── ÍCONES ──────────────────────────────────────────────────────────────────
const kFloatingActionIcon = Icon(
	CupertinoIcons.barcode_viewfinder,
	size: 50,
);

const kDeleteItemsIcon = Icon(
	CupertinoIcons.trash_fill,
	color: kDestructiveColor,
);

const kCartIcon = Icon(
	CupertinoIcons.cart,
	size: 40,
);

const kDeleteActionIcon = Padding(
	padding: EdgeInsets.only(left: 35.0),
	child: Icon(Icons.delete, color: Colors.white),
);

const kRefreshIcon = Icon(
	CupertinoIcons.refresh_bold,
	color: kGreenColor,
	size: 45,
);

const kStepperAddIcon   = Icon(CupertinoIcons.add_circled_solid,  size: 35, color: CupertinoColors.black);
const kStepperMinusIcon = Icon(CupertinoIcons.minus_circle_fill,  size: 35, color: CupertinoColors.black);

// ─── OUTROS ──────────────────────────────────────────────────────────────────
const kDeleteItemsConstrains = BoxConstraints.tightFor(
	width: 48.0,
	height: 48.0,
);

const kProductScanLabelConstrains = BoxConstraints(maxHeight: 400);

const kAppBarBorderRadius = BorderRadius.only(
	bottomLeft:  Radius.circular(25.0),
	bottomRight: Radius.circular(25.0),
);
