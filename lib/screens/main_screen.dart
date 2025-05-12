import 'package:flutter/material.dart';
import 'cac_man_chinh/home_screen.dart';
import 'cac_man_chinh/transaction_screen.dart';
import 'cac_man_chinh/budget_screen.dart';
import 'cac_man_chinh/profile_screens.dart';

class MainManagerScreen extends StatefulWidget {
  const MainManagerScreen({super.key});

  @override
  _MainManagerScreenState createState() => _MainManagerScreenState();
}

class _MainManagerScreenState extends State<MainManagerScreen> {
  int _selectedIndex = 2;


  final List<Widget> _screens = [
    HomeScreen(title: 'Trang chủ'),
    TransactionsScreen(title: 'Sổ giao dịch'),
    BudgetScreen(title: 'Ngân sách'),
    ProfileScreens(title: 'Hồ sơ'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt),label: 'Giao dịch',),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet),label: 'Ngân sách',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}
