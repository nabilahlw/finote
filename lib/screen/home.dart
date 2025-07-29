import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/data_services.dart';
import 'package:myapp/data/model/add_model.dart';
import 'package:myapp/screen/add.dart';

class Home extends StatefulWidget {
  final FirebaseDataService dataService;

  const Home({super.key, required this.dataService});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showIcons = false;
  String _username = 'Your Name';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  /// Ambil nama user setelah widget ter-mount
  void _loadUsername() async {
    final name = await widget.dataService.getUserName();
    if (mounted) {
      setState(() {
        _username = name;
      });
    }
  }

  /// Format angka ke Rupiah
  String formatRupiah(double value) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<AddData>>(
        stream: widget.dataService.getDataStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dataList = snapshot.data!;
          final total = dataList.fold<double>(
            0,
            (sum, d) => sum + (d.type == 1 ? d.amount : -d.amount),
          );
          final income = dataList
              .where((d) => d.type == 1)
              .fold<double>(0, (sum, d) => sum + d.amount);
          final expenses = dataList
              .where((d) => d.type == 0)
              .fold<double>(0, (sum, d) => sum + d.amount);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(total, income, expenses)),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
              SliverToBoxAdapter(child: _buildTitle()),
              if (dataList.isEmpty)
                SliverToBoxAdapter(child: _buildEmpty())
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _buildTile(dataList[i]),
                    childCount: dataList.length,
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffFA993B),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddScreen(
              dataService: widget.dataService,
              onSave: (_) {},
            ),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(double total, double income, double expenses) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background card
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xff5E4392),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good afternoon',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE0DFDF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _username,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Balance card
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              color: const Color(0xffFA993B),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: const Color(0x801F7D79).withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 6,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.more_horiz, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    formatRupiah(total),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIncomeExpenseRow('Income', Icons.arrow_downward),
                      _buildIncomeExpenseRow('Expenses', Icons.arrow_upward),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatRupiah(income),
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        formatRupiah(expenses),
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseRow(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Transactions History',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => setState(() => showIcons = !showIcons),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTile(AddData item) {
    final dt = item.datetime;
    final day = DateFormat('EEE').format(dt);
    final formattedDate = DateFormat('yyyy-MM-dd').format(dt);

    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (_) => widget.dataService.deleteData(item.id!),
      child: ListTile(
        title: Text(
          item.name,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '$day $formattedDate',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcons) ...[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddScreen(
                      dataService: widget.dataService,
                      editData: item,
                      onSave: (_) {},
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => widget.dataService.deleteData(item.id!),
              ),
            ],
            const SizedBox(width: 8),
            Text(
              formatRupiah(item.amount),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: item.type == 1 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
