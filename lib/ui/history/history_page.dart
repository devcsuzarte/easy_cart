import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/models/history.dart';
import 'package:easy_cart/ui/history/history_item.dart';
import 'package:easy_cart/ui/history/history_viewmodel.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

	List<Cart> historyList = List.empty();

	String getConvertedDate(String date){
		DateTime convertedDate =  DateTime.fromMillisecondsSinceEpoch(
			int.parse(date)
		);

		return DateFormat.yMMMd().format(convertedDate);
	}

  	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<HistoryViewmodel>.reactive(
			viewModelBuilder: () => HistoryViewmodel(
				productManager: context.read<ProductManager>()
			),
			onViewModelReady: (model) {
				model.history.onChange.listen(
					(list) => historyList = list.neu
				);
			} ,
			builder: (context, model, widget) => Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.green,
				foregroundColor: Colors.white,
				title: Text(
					'Histórico de Compras',
					style: TextStyle(
						fontWeight: FontWeight.w600
					)
				)
			),
			body: Padding(
				padding: const EdgeInsets.all(15.0),
				child: ListView.separated(
					itemBuilder: (context, index) => HistoryItem(
						date: getConvertedDate(historyList[index].date),
						total: historyList[index].total,
					),
					separatorBuilder: (context, index) => const SizedBox(height: 8), 
					itemCount: historyList.length
					)
				)
			)
		);
	}
}