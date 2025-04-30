import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  BudgetScreen({super.key, required this.title});

  final String title;

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text('Ngân sách'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 100, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              'Chạm + để thêm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Số giao dịch'),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.transparent), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Ngân sách'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home', arguments: {'animation': 'slide'});
          if (index == 1) Navigator.pushNamed(context, '/transactions', arguments: {'animation': 'slide'});
          if (index == 4) Navigator.pushNamed(context, '/profile', arguments: {'animation': 'slide'});
        },
      ),
    );
  }
}
