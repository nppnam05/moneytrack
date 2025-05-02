import 'package:flutter/material.dart';
import 'giao_dich/add_transaction.dart';
import 'giao_dich/upd_transaction.dart';


class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key, required this.title});

  final String title;

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _screens = [
    UpdTransaction(title: "Xóa và sửa giao dịch"),
    AddTransaction(title: "Thêm giao dịch"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Xóa & Sửa giao dịch'),
            Tab(text: 'Thêm giao dịch'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:[
          _screens[0],
          _screens[1]
        ],
      ),
    );
  }
}