import 'package:flutter/material.dart';
import 'package:moneytrack/models/budget.dart';

class UpdBudgetScreen extends StatefulWidget {
  const UpdBudgetScreen({super.key, required this.title});

  final String title;

  @override
  _UpdBudgetScreenState createState() => _UpdBudgetScreenState();
}

class _UpdBudgetScreenState extends State<UpdBudgetScreen> {
  // Danh sách Budgets giả lập
  List<Budget> _budgets = [
    Budget(1, 1, 1, 5000000, 10, 2023, 1696118400000), // Ăn uống
    Budget(2, 1, 2, 3000000, 10, 2023, 1696118400000), // Mua sắm
    Budget(3, 1, 3, 2000000, 10, 2023, 1696118400000), // Di chuyển
  ];

  // Danh sách category giả lập để hiển thị tên danh mục
  final Map<int, String> _categories = {
    1: 'Ăn uống',
    2: 'Mua sắm',
    3: 'Di chuyển',
    4: 'Giải trí',
  };

  // Biến để lưu trạng thái chỉnh sửa
  Budget? _editingBudget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _budgets.isEmpty
          ? const Center(
              child: Text(
                'Không có ngân sách nào. Chạm + để thêm.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : _itemListNganSach(),
    );
  }

  // Hàm xóa Budget
  void _deleteBudget(int id) {
    setState(() {
      _budgets.removeWhere((budget) => budget.id == id);
      _editingBudget = null; // Đóng form chỉnh sửa sau khi xóa
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa ngân sách')),
    );
  }

  // Hàm cập nhật Budget
  void _updateBudget(Budget budget, double newAmount, int newMonth, int newYear, int newCategoryId) {
    setState(() {
      budget.amount = newAmount;
      budget.month = newMonth;
      budget.year = newYear;
      budget.category_id = newCategoryId;
      _editingBudget = null; // Đóng form chỉnh sửa sau khi cập nhật
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật ngân sách')),
    );
  }

  // Hàm tạo form chỉnh sửa
  Widget _createItemDetail(Budget budget) {
    TextEditingController amountController = TextEditingController(text: budget.amount.toString());
    TextEditingController monthController = TextEditingController(text: budget.month.toString());
    TextEditingController yearController = TextEditingController(text: budget.year.toString());
    int? selectedCategoryId = budget.category_id;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown để chọn danh mục
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Danh mục',
              border: OutlineInputBorder(),
            ),
            value: selectedCategoryId,
            items: _categories.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedCategoryId = newValue;
              });
            },
          ),
          const SizedBox(height: 8),
          // TextField để chỉnh sửa amount
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Số tiền',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          // TextField để chỉnh sửa month
          TextField(
            controller: monthController,
            decoration: const InputDecoration(
              labelText: 'Tháng',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          // TextField để chỉnh sửa year
          TextField(
            controller: yearController,
            decoration: const InputDecoration(
              labelText: 'Năm',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          // Nút "Sửa" và "Xóa"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  double newAmount = double.parse(amountController.text);
                  int newMonth = int.parse(monthController.text);
                  int newYear = int.parse(yearController.text);
                  _updateBudget(budget, newAmount, newMonth, newYear, selectedCategoryId!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(120, 40),
                ),
                child: const Text('Sửa'),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteBudget(budget.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(120, 40),
                ),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm tạo một item trong ListView
  Widget _createItem(Budget budget) {
    bool isEditing = _editingBudget == budget;
    DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(budget.created_at);

    return Card(
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Danh mục: ${_categories[budget.category_id] ?? 'Không xác định'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Số tiền: ${budget.amount}'),
                Text('Tháng: ${budget.month}/${budget.year}'),
                Text('Tạo: ${createdAt.day}/${createdAt.month}/${createdAt.year}'),
              ],
            ),
            onTap: () {
              setState(() {
                _editingBudget = isEditing ? null : budget; // nếu đã click trước đó thì trả về null
              });
            },
          ),
          if (isEditing) _createItemDetail(budget),
        ],
      ),
    );
  }

  // Hàm tạo ListView chứa danh sách Budgets
  Widget _itemListNganSach() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _budgets.length,
      itemBuilder: (context, index) {
        return _createItem(_budgets[index]);
      },
    );
  }

}