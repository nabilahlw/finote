import 'package:flutter/material.dart';
import 'package:myapp/data/data_services.dart';
import 'package:myapp/screen/add.dart';
import 'package:myapp/screen/home.dart';
import 'package:myapp/screen/statistic.dart';
import 'package:myapp/screen/wallet.dart';

class Bottom extends StatefulWidget {
  final FirebaseDataService dataService;

  const Bottom({super.key, required this.dataService});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int selectedIndex = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      Home(dataService: widget.dataService),
      AddScreen(
        dataService: widget.dataService,
        onSave: (newData) {
          widget.dataService.addData(newData);
        },
      ),
      Statistics(dataService: widget.dataService),
      const Wallet(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xff5E4392),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          onTap: (index) => setState(() => selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }
}
