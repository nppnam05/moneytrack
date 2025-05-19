import 'package:flutter/material.dart';
import 'package:moneytrack/models/budget.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/utils/database/database_api.dart';

class UpdBudgetScreen extends StatefulWidget {
  const UpdBudgetScreen({super.key, required this.title});

  final String title;

  @override
  _UpdBudgetScreenState createState() => _UpdBudgetScreenState();
}

class _UpdBudgetScreenState extends State<UpdBudgetScreen>
    with WidgetsBindingObserver {
  // Danh sách Budgets giả lập
  List<Budget> budgets = [];

  // Danh sách category giả lập để hiển thị tên danh mục
  List<Categories> _categories = [];

  // Biến để lưu trạng thái chỉnh sửa
  Budget? _editingBudget;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // gọi dữ liệu lần đầu
    _loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Gọi hàm cập nhật dữ liệu
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body:
          budgets.isEmpty
              ? const Center(
                child: Text(
                  'Không có ngân sách nào. Chạm + để thêm.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : _itemListNganSach(),
    );
  }

  // Hàm tạo form chỉnh sửa
  Widget _createItemDetail(Budget budget) {
    TextEditingController amountController = TextEditingController(
      text: budget.amount.toString(),
    );


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown để chọn category
            DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Danh mục',
              border: OutlineInputBorder(),
            ),
            value: budget.categoryId,
            items:
                _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
            onChanged: (newValue) {
              setState(() {
               budget.categoryId = newValue!;     
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
            readOnly: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          // Thay thế DropdownButtonFormField<int> cho tháng:
          TextFormField(
            initialValue: budget.month.toString(),
            decoration: const InputDecoration(
              labelText: 'Tháng',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 8),
          // Thay thế DropdownButtonFormField<int> cho năm:
          TextFormField(
            initialValue: budget.year.toString(),
            decoration: const InputDecoration(
              labelText: 'Năm',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 16),
          // Nút "Sửa" và "Xóa"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _updateBudget(budget);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(120, 40),
                ),
                child: const Text('Sửa'),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteBudget(budget.id!);
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
  Widget _createItem(Budget budget, int index) {
    bool isEditing = _editingBudget == budget;
    DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(budget.createdAt);

    return Card(
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Danh mục: ${index + 1} ${_categories.firstWhere((cate) => cate.id == budget.categoryId, orElse: () => Categories(id: 0, name: 'Không xác định', cost: 0.0)).name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Số tiền: ${budget.amount}'),
                Text('Tháng: ${budget.month}/${budget.year}'),
                Text(
                  'Tạo: ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                ),
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
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        return _createItem(budgets[index], index);
      },
    );
  }

  // Hàm xóa Budget
  void _deleteBudget(int id) {
    var budget = budgets.where((it) => it.id == id).toList()[0];

    DatabaseApi.deleteBudget(
      budget,
      onSuccess: () {
        debugPrint("Xoa thanh cong");
      },
      onError: (error) {},
    );

    setState(() {
      budgets.removeWhere((it) => it.id == id);
      _editingBudget = null; // Đóng form chỉnh sửa sau khi xóa
    });


    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa ngân sách')));
  }


  // Hàm cập nhật Budget
  void _updateBudget(
    Budget budget,
  ) {

    DatabaseApi.updateBudget(
        budget,
        onSuccess: () {},
        onError: (Error) {},
      );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật ngân sách')));

    setState(() {
      _editingBudget = null; // Đóng form chỉnh sửa sau khi cập nhật
    });
  }

  Future<void> _loadData() async {

    _categories.clear();
    budgets.clear();

    var resultCategory = await DatabaseApi.getAllCategories();
    var resultBudget = await DatabaseApi.getBudgetsByUserId(0);

    setState(() {
      _categories.addAll(resultCategory);
      budgets.addAll(resultBudget);
    });
  }
}
