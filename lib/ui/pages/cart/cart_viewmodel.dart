import 'dart:collection';
import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:easy_cart/core/database.dart';
import '../data/models/product.dart';

class ProductData extends ChangeNotifier{

  List<Product> _productsList = [];
  double totalCartPrice = 0.0;

  UnmodifiableListView<Product> get products {
    return UnmodifiableListView(_productsList);
  }


  void addProduct(Product product) {
    _productsList.add(product);
    var price = product.labelPrice!.replaceAll(',', '.');
    EZCartDB().create(title: product.labelTitle!, price: double.parse(price), amount: product.amount!);
    showData();
  }

  void showData() async{
    _productsList = await EZCartDB().fetchAll;
    setTotalCartPrice();
    notifyListeners();
  }

  void deleteProduct(int productID) {
    EZCartDB().delete(id: productID);
    showData();
  }

  void cleanCartList() {
    EZCartDB().deleteTable();
    showData();
  }


  void setTotalCartPrice() {
    var total = 0.0;
    for (Product product in _productsList) {
      total = total + (double.parse(product.labelPrice!) * product.amount!);
    }
    totalCartPrice = total;
  }
}