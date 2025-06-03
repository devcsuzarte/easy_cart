import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// COLORS

const kProductLabelColor = Color(0xFFFFF203);
const kPrimaryColor = Color(0xFFA8E6CF);
const kSecondaryColor = CupertinoColors.systemGreen;
const kLightColor = Color(0xFFF5F5F5);
const kDarkColor = Color(0xFF333333);
const kDestructiveColor = Colors.red;

// TEXT
const kDialogTitleText = Text('Deseja limpar o carrinho?');
const kDialogContentText = Text('Deseja limpar o carrinho?');
const kDialogActionDefaultText = Text('Sim');
const kDialogActionDismissText = Text('Não');


const kBodyTextStyle = TextStyle(
  fontSize: 20.0,
);
const kBodyWhiteTextStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
);

const kLargeTextStyle = TextStyle(
    fontSize: 40.0
);

const kTitleTextStyle = TextStyle(
  fontSize: 35,
  fontWeight: FontWeight.w700,
  color: kDarkColor,
);

const kProductLabelTextFieldStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w600,
);

const kPriceCellTextStyle = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
);

const kPriceLabelTextStyle = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

const kPriceTextInputDecoration = InputDecoration(
  hintText: "00,00",
  border: InputBorder.none,
);

const kProductLabelTextFieldDecoration = InputDecoration(
    hintText: 'PRODUTO',
    border: InputBorder.none
);

// ICONS
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
  child: Icon(Icons.delete, color: Colors.white,),
);

const kRefreshIcon = Icon(
  CupertinoIcons.refresh_bold,
  color: CupertinoColors.systemGreen,
  size: 45,
);

const kStepperAddIcon = Icon(CupertinoIcons.add_circled_solid, size: 35, color: CupertinoColors.black,);

const kStepperMinusIcon = Icon(CupertinoIcons.minus_circle_fill, size: 35, color: CupertinoColors.black,);

// OTHERS

const kDeleteItemsConstrains = BoxConstraints.tightFor(
  width: 48.0,
  height: 48.0,
);

const kProductScanLabelConstrains = BoxConstraints(maxHeight: 400);

const kAppBarBorderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(25.0),
  bottomRight: Radius.circular(25.0),
);