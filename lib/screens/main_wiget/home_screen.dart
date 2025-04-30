import 'package:flutter/material.dart';
import 'package:moneytrack/models/category_static.dart';

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
  List<CategoryStatic> CategoryStaticList = [
    CategoryStatic("Food", 1000),
    CategoryStatic("Rental", 100),
    CategoryStatic("Shopping", 50),
  ];
  List<CategoryStatic> array = [
  CategoryStatic("Food", 1000),
  CategoryStatic("Rental", 100),
  CategoryStatic("Shopping", 50),
  CategoryStatic("Transport", 200),
  CategoryStatic("Entertainment", 150),
  CategoryStatic("Utilities", 80),
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
            _radioThoiGian(),
            const SizedBox(height: 10),
            Text(
              'Chi tiêu nhiều nhất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _itemListChiTieu(CategoryStaticList),
            Text(
              'Các khoản chi tiêu khác',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _itemListChiTieu(array)
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
    return 
    Container(
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
  Widget _itemListChiTieu(List<CategoryStatic> CategoryStaticList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: CategoryStaticList.length,
      itemBuilder: (context, index) {
        final categoryStatic = CategoryStaticList[index];
        return _createItem(categoryStatic);
      },
    );
  }

  Widget _createItem(CategoryStatic category) {
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
      trailing: Text('${(category.cost/1150.0).toStringAsFixed(2)}%'),
    );
  }

}
