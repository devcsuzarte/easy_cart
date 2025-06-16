import 'dart:ffi';
import 'package:easy_cart/ui/widgets/product_cell.dart';
import 'package:flutter/cupertino.dart';

class TextUtils {
// Apply unit test here
 static String getConvertedPrice(String priceText) {
    String priceConverted = "";
    String price = priceText.replaceAll(',', '.');
    for (var char in price.characters) {
      switch (char) {
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
        case ".":
          priceConverted = priceConverted + char;
        default:
          break;
      }
    }

    return priceConverted;
  }

  static bool isTextValid(String text) {
    if (text.length > 20 && text.contains(" ")){
      getConvertedPrice(text);
      return true;
    } else {
      return false;
    }
  }

 static bool isPriceValid(String price) {
    if((price.contains(',')) || price.contains('.')){
      return true;
    } else {
      return false;
    }
  }

}