import 'package:easy_cart/core/constants.dart';
import 'package:easy_cart/core/models/cost_comparison.dart';
import 'package:easy_cart/ui/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({
    super.key,
    this.initialName = '',
    this.initialPrice = '',
    this.fromSheet = false,
  });
  final String initialName;
  final String initialPrice;
  final bool fromSheet;

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _Entry {
  _Entry({String name = '', String price = ''})
    : name = TextEditingController(text: name),
      price = TextEditingController(text: price);
  final TextEditingController name;
  final TextEditingController price;
  final quantity = TextEditingController();
  MeasureUnit unit = MeasureUnit.unit;
  void dispose() {
    name.dispose();
    price.dispose();
    quantity.dispose();
  }
}

class _ComparisonPageState extends State<ComparisonPage> {
  final _form = GlobalKey<FormState>();
  late final List<_Entry> _entries;
  List<ComparisonProduct>? _results;
  String? _error;
  final _currency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 4,
  );

  @override
  void initState() {
    super.initState();
    _entries = [
      _Entry(name: widget.initialName, price: widget.initialPrice),
      _Entry(),
    ];
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _invalidate() => setState(() {
    _results = null;
    _error = null;
  });

  void _compare() {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    try {
      final ranked = rankProducts([
        for (var i = 0; i < _entries.length; i++)
          ComparisonProduct(
            name:
                _entries[i].name.text.trim().isEmpty
                    ? 'Produto ${i + 1}'
                    : _entries[i].name.text.trim(),
            price: parseComparisonNumber(_entries[i].price.text)!,
            quantity: parseComparisonNumber(_entries[i].quantity.text)!,
            unit: _entries[i].unit,
          ),
      ]);
      setState(() {
        _results = ranked;
        _error = null;
      });
    } on ArgumentError {
      setState(() {
        _results = null;
        _error =
            'Use medidas compatíveis em todos os produtos: g/kg, ml/L, cm/m ou unidade. Verifique também os valores informados.';
      });
    }
  }

  Widget _numberField(TextEditingController controller, String label) =>
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator:
            (value) =>
                parseComparisonNumber(value ?? '') == null
                    ? 'Informe um valor maior que zero'
                    : null,
      );

  Widget _productCard(int index) {
    final entry = _entries[index];
    return Card(
      key: ObjectKey(entry),
      color: kSurfaceColor,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Produto ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Remover produto ${index + 1}',
                  icon: const Icon(Icons.close),
                  onPressed:
                      _entries.length <= 2
                          ? null
                          : () {
                            setState(() {
                              _entries.removeAt(index);
                              _results = null;
                              _error = null;
                            });
                            // The removed fields must unmount before their controllers are disposed.
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => entry.dispose(),
                            );
                          },
                ),
              ],
            ),
            TextFormField(
              controller: entry.name,
              decoration: const InputDecoration(
                labelText: 'Nome (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            _numberField(entry.price, 'Preço da embalagem (R\$)'),
            const SizedBox(height: 14),
            _numberField(entry.quantity, 'Conteúdo da embalagem'),
            const SizedBox(height: 14),
            DropdownButtonFormField<MeasureUnit>(
              value: entry.unit,
              decoration: const InputDecoration(
                labelText: 'Medida',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final unit in MeasureUnit.values)
                  DropdownMenuItem(value: unit, child: Text(unit.label)),
              ],
              onChanged: (value) {
                entry.unit = value!;
                _invalidate();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    final tied =
        results != null &&
        results
                .where(
                  (p) => sameUnitPrice(p.unitPrice, results.first.unitPrice),
                )
                .length >
            1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custo-benefício'),
        backgroundColor: kBgColor,
      ),
      bottomNavigationBar:
          widget.fromSheet
              ? null
              : DefaultNavBar(
                selectedIndex: 3,
                onTap: (index) => navigateToTab(context, index, 3),
              ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _form,
            onChanged: _invalidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Compare o preço pela mesma quantidade',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Informe o preço e o conteúdo total de cada embalagem. Ex.: 500 ml, 1 kg ou 12 unidades. O menor preço por medida é a melhor opção.',
                ),
                const SizedBox(height: 18),
                for (var i = 0; i < _entries.length; i++) _productCard(i),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _entries.add(_Entry()..unit = _entries.first.unit);
                      _results = null;
                      _error = null;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar produto'),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _compare,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Comparar produtos'),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                if (results != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    tied
                        ? 'Empate no melhor custo-benefício'
                        : 'Melhor custo-benefício',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  for (final product in results)
                    Card(
                      color:
                          sameUnitPrice(
                                product.unitPrice,
                                results.first.unitPrice,
                              )
                              ? kGreenSoftColor
                              : kSurfaceColor,
                      child: ListTile(
                        leading: Icon(
                          sameUnitPrice(
                                product.unitPrice,
                                results.first.unitPrice,
                              )
                              ? Icons.verified_outlined
                              : Icons.shopping_bag_outlined,
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          '${_currency.format(product.unitPrice)} / ${product.unit.baseLabel}'
                          '${sameUnitPrice(product.unitPrice, results.first.unitPrice) ? '\nMenor preço por medida' : '\nA melhor opção economiza ${NumberFormat('0.##', 'pt_BR').format((1 - results.first.unitPrice / product.unitPrice) * 100)}% por medida em relação a este produto.'}',
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
