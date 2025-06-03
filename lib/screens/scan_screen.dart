import 'dart:ui';
import 'package:easy_cart/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_cart/controller/text_manager.dart';
import 'package:easy_cart/models/product.dart';
import 'package:easy_cart/controller/product_data_manager.dart';
import 'package:provider/provider.dart';
import 'package:easy_cart/controller/scan_manager.dart';
import 'package:easy_cart/widgets/scan_screen_widgets/price_label.dart';
import 'package:easy_cart/widgets/scan_screen_widgets/amount_stepper.dart';
import 'package:easy_cart/widgets/scan_screen_widgets/product_label.dart';

class ScanScreen extends StatefulWidget {

  late List<String> labelsList;
  late List<String> priceList;
  ScanScreen({super.key, required this.labelsList, required this.priceList});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final textManager = TextManager();
  final scanManager = ScanManager();
  final textLabelController = TextEditingController();
  final textPriceController = TextEditingController();

  int labelIndex = 0;
  int priceIndex = 0;
  int amount = 1;

  @override
  void initState() {
    super.initState();
    textLabelController.text = widget.labelsList.length > 0 ? widget.labelsList[labelIndex] : "PRODUTO";
    textPriceController.text = widget.priceList.length > 0 ? widget.priceList[priceIndex] : "0,00";
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: ProductLabel(
                    textLabelController: textLabelController,
                    onPressed: () {
                      labelIndex < widget.labelsList.length - 1 ? labelIndex++ : labelIndex = 0;
                      textLabelController.text = widget.labelsList[labelIndex];
                    })
              ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 150),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AmountStepper(
                            amount: amount,
                            addPressed: () {
                              setState(() {
                                amount++;
                              });
                            },
                            minusPressed: () {
                              setState(() {
                                amount > 1 ? amount-- : amount = 1;
                              });
                            }
                            ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PriceLabel(
                              textPriceController: textPriceController,
                              onPressed: () {
                                priceIndex < widget.priceList.length - 1 ? priceIndex++ : priceIndex = 0;
                                textPriceController.text = widget.priceList[priceIndex];
                              },
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Expanded(
                              child: MaterialButton(
                                color: CupertinoColors.systemGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                onPressed: () {
                                  var newProduct = Product(amount: amount, labelPrice:  textPriceController.text, labelTitle:  textLabelController.text);
                                  Provider.of<ProductData>(context, listen: false).addProduct(newProduct);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                          'Adicionar Item',
                                        textAlign: TextAlign.center,
                                        style: kBodyWhiteTextStyle,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.cart_badge_plus,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
      ),
    );
  }
}
