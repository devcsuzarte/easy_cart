enum MeasureUnit {
  ml('ml', 'volume', 0.001, 'L'),
  liter('L', 'volume', 1, 'L'),
  gram('g', 'mass', 0.001, 'kg'),
  kilogram('kg', 'mass', 1, 'kg'),
  unit('unidade', 'count', 1, 'unidade'),
  meter('m', 'length', 1, 'm'),
  centimeter('cm', 'length', 0.01, 'm');

  const MeasureUnit(this.label, this.dimension, this.factor, this.baseLabel);
  final String label;
  final String dimension;
  final double factor;
  final String baseLabel;
}

/// Accepts decimal commas or dots, and Brazilian thousands separators.
double? parseComparisonNumber(String text) {
  var value = text.replaceAll('R\$', '').replaceAll(RegExp(r'\s'), '');
  if (value.contains(',')) {
    value = value.replaceAll('.', '').replaceAll(',', '.');
  }
  if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) return null;
  final number = double.tryParse(value);
  return number != null && number.isFinite && number > 0 ? number : null;
}

class ComparisonProduct {
  const ComparisonProduct({
    required this.name,
    required this.price,
    required this.quantity,
    required this.unit,
  });
  final String name;
  final double price;
  final double quantity;
  final MeasureUnit unit;
  double get unitPrice => price / (quantity * unit.factor);
}

List<ComparisonProduct> rankProducts(List<ComparisonProduct> products) {
  if (products.length < 2 ||
      products.any(
        (p) =>
            p.unit.dimension != products.first.unit.dimension ||
            !p.price.isFinite ||
            p.price <= 0 ||
            !p.quantity.isFinite ||
            p.quantity <= 0 ||
            !p.unitPrice.isFinite ||
            p.unitPrice <= 0,
      )) {
    throw ArgumentError(
      'Informe ao menos dois produtos com medidas compatíveis e valores positivos.',
    );
  }
  return [...products]..sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
}

bool sameUnitPrice(double a, double b) => (a - b).abs() <= a.abs() * 1e-9;
