import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/data_services.dart';
import 'package:myapp/data/model/add_model.dart';
import 'package:get/get.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
class _WalletState extends State<Wallet> {
  final FirebaseDataService dataService = Get.find<FirebaseDataService>();
  String _username = 'Your Name';

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  void fetchUsername() async {
    final name = await dataService.getUserName();
    setState(() {
      _username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: StreamBuilder<List<AddData>>(
                stream: dataService.getDataStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!;
                  data.sort((a, b) => b.datetime.compareTo(a.datetime));
                  double totalBalance = 0.0;

                  return data.isEmpty
                      ? const Center(child: Text('No transactions available.'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Date Time')),
                              DataColumn(label: Text('Total Balance')),
                            ],
                            rows: List.generate(data.length, (index) {
                              final item = data[index];
                              final isIncome = item.type == 1;
                              totalBalance += isIncome ? item.amount : -item.amount;
                              final rowColor = isIncome
                                  ? Colors.green.shade100
                                  : Colors.red.shade100;

                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) => rowColor,
                                ),
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(item.name)),
                                  DataCell(Text(item.description)),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(item.amount),
                                      style: TextStyle(
                                        color: isIncome ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                            
                                      isIncome ? 'Income' : 'Expense',
                                      style: TextStyle(
                                        color: isIncome ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(
                                      DateFormat('yyyy-MM-dd HH:mm').format(item.datetime))),
                                  DataCell(
  Text(
    currencyFormat.format(totalBalance),
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
),
                                ],
                              );
                            }),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xff5E4392),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 40),
      
      // Sapaan waktu
      const Text(
        'Good afternoon',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color.fromARGB(255, 224, 223, 223),
        ),
      ),

      // Nama pengguna
      Text(
        _username,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ],
  ),
),

    );
  }
}
