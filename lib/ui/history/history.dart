import 'package:easy_cart/core/models/history.dart';
import 'package:easy_cart/ui/history/history_viewmodel.dart';
import 'package:easy_cart/ui/widgets/container_default.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

	List<History> historyList = List.empty();

  	@override
	Widget build(BuildContext context) {
		return ViewModelBuilder<HistoryViewmodel>.reactive(
			viewModelBuilder: () => HistoryViewmodel(),
			onViewModelReady: (model) {
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
					itemBuilder: (context, index) => ContainerDefault(
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											'Data',
											style: TextStyle(
												fontSize: 18,
												fontWeight: FontWeight.w600
											)
										),
										Text(
											'Valor total:',
											style: TextStyle(
												fontSize: 15,
												color: Color(0xFF474747)
											)
										)
									]
								)
							]
						)
					),
					separatorBuilder: (context, index) => const SizedBox(height: 8), 
					itemCount: historyList.length
					)
				)
			)
		);
	}
}