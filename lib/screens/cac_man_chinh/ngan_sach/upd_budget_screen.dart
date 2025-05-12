import 'package:flutter/material.dart';
import 'package:moneytrack/models/budget.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/services/database_api.dart';

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
  List<Categories> categories = [];

  // Biến để lưu trạng thái chỉnh sửa
  Budget? _editingBudget;
  Categories? _selectedCategory;
  int? _selectedCategoryID;
  int _userID = -1;

  int? monthSelected;
  int? yearSelected;

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
    TextEditingController monthController = TextEditingController(
      text: budget.month.toString(),
    );
    TextEditingController yearController = TextEditingController(
      text: budget.year.toString(),
    );

    _selectedCategory = categories.where((it) => it.id == budget.categoryId).toList()[0];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown để chọn category
          DropdownButtonFormField<Categories>(
            decoration: const InputDecoration(
              labelText: 'Danh mục',
              border: OutlineInputBorder(),
            ),
            value: _selectedCategory,
            items:
                categories.map((Categories category) {
                  return DropdownMenuItem<Categories>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
            onChanged: (Categories? newValue) {
              setState(() {
                _selectedCategoryID = newValue!.id!;
                _selectedCategory = newValue;
              });
            },
            validator:
                (value) => value == null ? 'Vui lòng chọn danh mục' : null,
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
          //  để nhập month
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Tháng',
              border: OutlineInputBorder(),
            ),
            value:
                monthController.text.isNotEmpty
                    ? int.tryParse(monthController.text)
                    : null,
            items: List.generate(12, (index) {
              int month = index + 1;
              return DropdownMenuItem(
                value: month,
                child: Text('Tháng $month'),
              );
            }),
            onChanged: (value) {
              setState(() {
                monthSelected = value;
                monthController.text = value.toString();
              });
            },
          ),
          const SizedBox(height: 8),
          //  để nhập year
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Năm',
              border: OutlineInputBorder(),
            ),
            value:
                yearController.text.isNotEmpty
                    ? int.tryParse(yearController.text)
                    : null,
            items: List.generate(10, (index) {
              int year = DateTime.now().year - 8 + index;
              return DropdownMenuItem(value: year, child: Text('$year'));
            }),
            onChanged: (value) {
              setState(() {
                yearSelected = value;
                yearController.text = value.toString();
              });
            },
          ),
          const SizedBox(height: 16),
          // Nút "Sửa" và "Xóa"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // update
                  double newAmount = double.parse(amountController.text);
                  int newMonth = int.parse(monthController.text);
                  int newYear = int.parse(yearController.text);
                  _updateBudget(
                    budget,
                    newAmount,
                    monthSelected ?? newMonth,
                    yearSelected ?? newYear,
                    _selectedCategoryID ?? _selectedCategory!.id!,
                  );
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
              'Danh mục: ${index + 1} ${categories[budget.categoryId].name ?? 'Không xác định'}',
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
                _editingBudget =
                    isEditing
                        ? null
                        : budget; // nếu đã click trước đó thì trả về null
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
        print("Xoa thanh cong");
      },
      onError: (Error) {},
    );

    setState(() {
      budgets.removeWhere((budget) => budget.id == id);
      _editingBudget = null; // Đóng form chỉnh sửa sau khi xóa
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa ngân sách')));
  }

  // Hàm cập nhật Budget
  void _updateBudget(
    Budget budget,
    double newAmount,
    int newMonth,
    int newYear,
    int newIdCategory,
  ) {
    print("$newMonth");

    setState(() {
      budget.amount = newAmount;
      budget.month = newMonth;
      budget.year = newYear;
      budget.categoryId = newIdCategory;
      _editingBudget = null; // Đóng form chỉnh sửa sau khi cập nhật
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật ngân sách')));

    DatabaseApi.updateBudget(
      budget,
      onSuccess: () {
        print("Update thanh cong");
      },
      onError: (Error) {},
    );
  }

  Future<void> _loadData() async {
    _userID = LoginScreen.userid;

    categories.clear();
    budgets.clear();

    var resultCategory = await DatabaseApi.getAllCategories();
    var resultBudget = await DatabaseApi.getBudgetsByUserId(_userID);

    setState(() {
      categories.addAll(resultCategory);
      budgets.addAll(resultBudget);
    });
  }
}
