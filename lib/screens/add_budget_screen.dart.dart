import 'package:flutter/material.dart';

class AddBudgetScreen extends StatefulWidget {
  AddBudgetScreen({super.key, required this.title});

  final String title;

  @override
  _AddBudgetScreenState createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text('Thêm ngân sách'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, size: 100, color: Colors.blue),
              SizedBox(height: 10),
              Text(
                'Chạm + để thêm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home', arguments: {'animation': 'slide'});
                },
                child: Text('Tạo ngân sách'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text('Sử dụng ngân sách như thế nào?', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('Tạo ví mới'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance),
                    title: Text('Tạo tài khoản ngân hàng'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        },
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home', arguments: {'animation': 'slide'});
          if (index == 3) Navigator.pushNamed(context, '/budget', arguments: {'animation': 'slide'});
          if (index == 4) Navigator.pushNamed(context, '/profile', arguments: {'animation': 'slide'});
        },
      ),
    );
  }
}
