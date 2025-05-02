import 'package:flutter/material.dart';
import 'package:moneytrack/models/category.dart';
import 'package:moneytrack/models/budget.dart';

class AddBudgetScreen extends StatefulWidget {
  AddBudgetScreen({super.key, required this.title});

  final String title;

  @override
  _AddBudgetScreenState createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  List<Category> categories = [
    Category(id: 1,name: "Food",cost: 1000),
    Category(id: 2,name: "Rental",cost: 100),
    Category(id: 3,name: "Shopping",cost: 50),
  ];

  // Controller cho các TextField
  final _amountController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  // Biến để lưu category được chọn
  Category? _selectedCategory;

  final int _userId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm ngân sách')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 100,
                  color: Colors.blue,
                ),
                SizedBox(height: 10),
                Text(
                  'Chạm + để thêm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _inputWiget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputWiget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown để chọn category
          DropdownButtonFormField<Category>(
            decoration: const InputDecoration(
              labelText: 'Danh mục',
              border: OutlineInputBorder(),
            ),
            value: _selectedCategory,
            items:
                categories.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
            onChanged: (Category? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
            validator:
                (value) => value == null ? 'Vui lòng chọn danh mục' : null,
          ),
          const SizedBox(height: 16),
          // TextField để nhập amount
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Số tiền',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          // TextField để nhập month
          TextField(
            controller: _monthController,
            decoration: const InputDecoration(
              labelText: 'Tháng',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          // TextField để nhập year
          TextField(
            controller: _yearController,
            decoration: const InputDecoration(
              labelText: 'Năm',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          // Nút để thêm ngân sách
          ElevatedButton(
            onPressed: _addBudget,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Thêm ngân sách'),
          ),
        ],
      ),
    );
  }

  void _addBudget() {
    // Kiểm tra dữ liệu đầu vào
    if (_selectedCategory == null ||
        _amountController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }

    // Tạo Budgets mới
    Budget newBudget = Budget(
      id: 0,
      userId: _userId,
      categoryId: _selectedCategory!.id!,
      amount: double.parse(_amountController.text),
      month: int.parse(_monthController.text),
      year: int.parse(_yearController.text),
      createdAt: DateTime.now().millisecondsSinceEpoch, // created_at: Timestamp hiện tại
    );
  }
}
