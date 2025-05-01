import 'package:flutter/material.dart';
import 'ngan_sach/add_budget_screen.dart.dart';
import 'ngan_sach/upd_budget_screen.dart';
class BudgetScreen extends StatefulWidget {
  BudgetScreen({super.key, required this.title});

  final String title;

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _screens = [
    UpdBudgetScreen(title: "Xóa và sửa ngân sách"),
    AddBudgetScreen(title: "Thêm ngân sách"),
  ];
  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với số lượng tab bằng độ dài của _screens
    _tabController = TabController(length: _screens.length, vsync: this);
  }

  @override
  void dispose() {
    // Giải phóng TabController để tránh rò rỉ bộ nhớ
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Xóa & Sửa'),
            Tab(text: 'Thêm ngân sách'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _screens[0],
          _screens[1]
        ],
      ),
    );
  }
}