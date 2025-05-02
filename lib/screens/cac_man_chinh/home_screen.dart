import 'package:flutter/material.dart';
import 'package:moneytrack/models/category.dart';
import 'package:moneytrack/models/user.dart';
import '../../models/budget.dart';
import '../../widgets/chi_tieu_pie_chart.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum TimeRange { week, month }

class _HomeScreenState extends State<HomeScreen> {
  TimeRange _selectedRange = TimeRange.week;
  final costController = TextEditingController(text: '0 đ');
  var user = User(id: 1,name: "aaaa",email: "aaa",password: "a",totalExpenditure: 1000000000,totalRevenue: 100000000000);
  List<Category> categories = [
    Category(id: 1,name:  "Food",cost:  1000),
    Category(id:  2,name:  "Rental",cost:  100),
    Category(id:  3,name:  "Shopping",cost:  50),
  ];
  List<Category> array = [
    Category(id: 4,name:  "Food",cost:  1000),
    Category(id: 5,name:  "Rental",cost:  10),
    Category(id: 6,name: "Shopping",cost: 50),
    Category(id: 7,name: "Transport",cost: 200),
    Category(id: 8,name: "Entertainment",cost: 150),
    Category(id: 9,name: "Utilities",cost: 80),
  ];

  final List<Budget> budgets = [
    Budget(id: 1,userId: 1 ,categoryId: 1,amount: 5000000,month:  5,year:  2025,createdAt: 1696118400000),
    Budget(id:2,userId: 1 ,categoryId:  2,amount: 3000000,month:  5,year: 2025,createdAt: 1696118400000),
    Budget(id:3,userId: 1 ,categoryId: 3,amount: 2000000,month:  5,year:  2025,createdAt:  1696118400000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tienMat(),
            const SizedBox(height: 10),
            _tongThuChi(), // tổng thu, chi
            const SizedBox(height: 10),
            _radioThoiGian(),
            const SizedBox(height: 10),
            ChiTieuPieChart(categories: categories),
            const SizedBox(height: 10),
            Text(
              'Chi tiêu nhiều nhất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _itemListChiTieu(categories),
            Text(
              'Các khoản chi tiêu khác',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _itemListChiTieu(array),
            const SizedBox(height: 10),
            const Text(
              'Danh sách ngân sách',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _budgetList(), // danh sách ngân sách
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị danh sách ngân sách
  Widget _budgetList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        return ListTile(title: Text('${budget.amount.toStringAsFixed(0)} VNĐ'));
      },
    );
  }

  // Hàm tính và hiển thị tổng thu nhập
  Widget _tongThuChi() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng thu nhập:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user.totalRevenue.toStringAsFixed(0)} VNĐ',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng chi tiêu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${user.totalExpenditure.toStringAsFixed(0)} VNĐ',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // RadioListTile chọn thời gian
  Widget _radioThoiGian() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          RadioListTile<TimeRange>(
            title: const Text('Tuần'),
            value: TimeRange.week,
            groupValue: _selectedRange,
            onChanged: (value) {
              setState(() {
                _selectedRange = value!;
              });
            },
          ),
          RadioListTile<TimeRange>(
            title: const Text('Tháng'),
            value: TimeRange.month,
            groupValue: _selectedRange,
            onChanged: (value) {
              setState(() {
                _selectedRange = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  // Tiền mặt
  Widget _tienMat() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[300],
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tiền mặt',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: costController,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24, color: Colors.green),
                  decoration: const InputDecoration.collapsed(hintText: ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Danh sách chi tiêu
  Widget _itemListChiTieu(List<Category> Category) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Category.length,
      itemBuilder: (context, index) {
        final categoryStatic = Category[index];
        return _createItem(categoryStatic);
      },
    );
  }

  Widget _createItem(Category category) {
    IconData icon;
    Color color;

    // Gán icon và màu dựa theo tên danh mục
    switch (category.name.toLowerCase()) {
      case 'food':
        icon = Icons.fastfood;
        color = Colors.pinkAccent;
        break;
      case 'rental':
        icon = Icons.home;
        color = Colors.orangeAccent;
        break;
      case 'shopping':
        icon = Icons.shopping_bag;
        color = Colors.blueGrey;
        break;
      default:
        icon = Icons.category;
        color = Colors.grey;
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(category.name),
      trailing: Text('${(category.cost / 1150.0).toStringAsFixed(2)}%'),
    );
  }
}
