import 'package:easy_cart/core/managers/product_manager.dart';
import 'package:easy_cart/core/models/history.dart';
import 'package:easy_cart/ui/history/history_item.dart';
import 'package:easy_cart/ui/history/history_viewmodel.dart';
import 'package:easy_cart/ui/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/date_symbol_data_local.dart';

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

		return DateFormat.yMMMd('pt').format(convertedDate);
	}

	@override
	void initState() {
		WidgetsBinding.instance.addPostFrameCallback((_) {
			initializeDateFormatting(Localizations.localeOf(context).languageCode, null);
		});
		super.initState();
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
				backgroundColor: Colors.white,
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
			body: (!model.isBusy && historyList.isNotEmpty) ? Skeletonizer(
				enabled: model.isBusy,
			  child: Padding(
			  	padding: const EdgeInsets.all(15.0),
			  	child: ListView.separated(
			  		itemBuilder: (context, index) => Skeleton.leaf(
			  		  child: HistoryItem(
			  		  	date: getConvertedDate(historyList[index].date),
			  		  	total: historyList[index].total,
			  		  ),
			  		),
			  		separatorBuilder: (context, index) => const SizedBox(height: 8),
			  		itemCount: historyList.length
			  		)
			  	),
			) : Padding(
					padding: const EdgeInsets.symmetric(horizontal: 25.0),
						child: Align(
							child: Empty(
								imgUrl: 'assets/history.png',
								title: 'Nenhum histórico encontrado'
						)
					)
				)
			)
		);
	}
}