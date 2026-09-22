import 'package:easy_cart/core/models/cost_comparison.dart';
import 'package:flutter_test/flutter_test.dart';

ComparisonProduct product(double price, double quantity, MeasureUnit unit) =>
    ComparisonProduct(name: 'Produto', price: price, quantity: quantity, unit: unit);

void main() {
  test('converts volume and ranks three packages by normalized price', () {
    final ranked = rankProducts([
      product(6, 500, MeasureUnit.ml),
      product(10, 1, MeasureUnit.liter),
      product(18, 2, MeasureUnit.liter),
    ]);
    expect(ranked.map((p) => p.unitPrice), [9, 10, 12]);
  });
  test('converts mass and recognizes ties', () {
    final ranked = rankProducts([
      product(5, 500, MeasureUnit.gram),
      product(10, 1, MeasureUnit.kilogram),
    ]);
    expect(sameUnitPrice(ranked.first.unitPrice, ranked.last.unitPrice), isTrue);
  });
  test('compares unit packs and length', () {
    expect(product(12, 6, MeasureUnit.unit).unitPrice, 2);
    expect(product(10, 50, MeasureUnit.centimeter).unitPrice, 20);
  });
  test('rejects incompatible units, insufficient products and invalid numbers', () {
    expect(() => rankProducts([product(1, 1, MeasureUnit.ml), product(1, 1, MeasureUnit.gram)]), throwsArgumentError);
    expect(() => rankProducts([product(1, 1, MeasureUnit.unit)]), throwsArgumentError);
    for (final value in [0.0, -1.0, double.infinity, double.nan]) {
      expect(() => rankProducts([product(1, value, MeasureUnit.unit), product(1, 1, MeasureUnit.unit)]), throwsArgumentError);
    }
  });
  test('accepts Brazilian prices and decimal quantities', () {
    expect(parseComparisonNumber('R\$ 1.234,56'), 1234.56);
    expect(parseComparisonNumber('0,5'), .5);
    expect(parseComparisonNumber('1.5'), 1.5);
    for (final value in ['', '0', '-2', 'NaN', 'Infinity', '1,2,3']) {
      expect(parseComparisonNumber(value), isNull);
    }
  });
}
