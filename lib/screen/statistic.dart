import 'package:flutter/material.dart';
import 'package:myapp/data/data_services.dart';
import 'package:myapp/data/model/add_model.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class Statistics extends StatefulWidget {
  final FirebaseDataService dataService;
  const Statistics({super.key, required this.dataService});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final List<String> day = ['Day', 'Week', 'Month', 'Year'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<AddData>>(
          stream: widget.dataService.getDataStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final filteredData = _getFilteredData(snapshot.data!);

            return Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Statistics',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(day.length, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Container(
                          height: 40,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: selectedIndex == index ? const Color(0xFF2F7D79) : Colors.white,
                          ),
                          child: Text(
                            day[index],
                            style: TextStyle(
                              color: selectedIndex == index ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                _buildChart(filteredData),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Top Spending', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(Icons.swap_vert, size: 25, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final data = filteredData[index];
                      return ListTile(
                        title: Text(data.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(DateFormat('yyyy-MM-dd').format(data.datetime)),
                        trailing: Text(
                          'Rp ${data.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: data.type == 1 ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildChart(List<AddData> data) {
    Map<String, double> grouped = {};

    for (var d in data) {
      if (d.type == 0) { // only expenses
        final key = DateFormat('dd/MM').format(d.datetime);
        grouped[key] = (grouped[key] ?? 0) + d.amount;
      }
    }

    final labels = grouped.keys.toList();
    final values = grouped.values.toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(values.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 16,
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  return Text(
                    labels[val.toInt()],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  List<AddData> _getFilteredData(List<AddData> data) {
    switch (selectedIndex) {
      case 0:
        return data.where((item) => item.datetime.isSameDate(DateTime.now())).toList();
      case 1:
        return data.where((item) => item.datetime.isWithinWeek(DateTime.now())).toList();
      case 2:
        return data.where((item) => item.datetime.isWithinMonth(DateTime.now())).toList();
      case 3:
        return data.where((item) => item.datetime.isWithinYear(DateTime.now())).toList();
      default:
        return [];
    }
  }
}

extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) => year == other.year && month == other.month && day == other.day;
  bool isWithinWeek(DateTime other) => difference(other).inDays.abs() < 7;
  bool isWithinMonth(DateTime other) => year == other.year && month == other.month;
  bool isWithinYear(DateTime other) => year == other.year;
}
