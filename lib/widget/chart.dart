import 'package:flutter/material.dart';
import 'package:myapp/data/model/add_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatelessWidget {
  final List<AddData> transactions;
  final int indexx;

  const Chart({
    super.key,
    required this.transactions,
    required this.indexx,
  });

  @override
  Widget build(BuildContext context) {
    final filteredData = _filterTransactions(transactions, indexx);
    if (filteredData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final salesData = _generateSalesData(filteredData, indexx);

    return SizedBox(
      width: double.infinity,
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        series: <SplineSeries<SalesData, String>>[
          SplineSeries<SalesData, String>(
            color: const Color.fromARGB(255, 47, 125, 121),
            width: 3,
            dataSource: salesData,
            xValueMapper: (SalesData sales, _) => sales.label,
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        ],
      ),
    );
  }

  List<AddData> _filterTransactions(List<AddData> data, int filterIndex) {
    final now = DateTime.now();
    switch (filterIndex) {
      case 0:
        return data.where((d) => _isSameDate(d.datetime, now)).toList();
      case 1:
        return data.where((d) => d.datetime.isAfter(now.subtract(const Duration(days: 7)))).toList();
      case 2:
        return data.where((d) => d.datetime.month == now.month && d.datetime.year == now.year).toList();
      case 3:
        return data.where((d) => d.datetime.year == now.year).toList();
      default:
        return [];
    }
  }

  List<SalesData> _generateSalesData(List<AddData> data, int indexx) {
    final Map<String, double> grouped = {};

    for (var d in data) {
      String key;
      switch (indexx) {
        case 0:
          key = d.datetime.hour.toString();
          break;
        case 1:
        case 2:
          key = d.datetime.day.toString();
          break;
        case 3:
          key = d.datetime.month.toString();
          break;
        default:
          key = d.datetime.day.toString();
      }

      double amount = d.type == 1 ? d.amount : -d.amount;
      grouped[key] = (grouped[key] ?? 0) + amount;
    }

    return grouped.entries
        .map((e) => SalesData(e.key, e.value.round()))
        .toList()
      ..sort((a, b) => int.parse(a.label).compareTo(int.parse(b.label)));
  }

  bool _isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}

class SalesData {
  SalesData(this.label, this.sales);
  final String label;
  final int sales;
}
