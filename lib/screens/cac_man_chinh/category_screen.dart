import 'package:flutter/material.dart';
import 'package:moneytrack/screens/cac_man_chinh/categoty/add_category_screen.dart';
import 'package:moneytrack/screens/cac_man_chinh/categoty/upd_category_screen.dart';
class CategoryScreen extends StatefulWidget {
  final String title;
  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _screens = [
    UpdCategoryScreen(title: "Xóa và sửa loại giao dịch"),
    AddCategoryScreen(title: "Thêm loại giao dịch"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
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
            Tab(text: 'Thêm loại giao dịch'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
    );
  }
}
