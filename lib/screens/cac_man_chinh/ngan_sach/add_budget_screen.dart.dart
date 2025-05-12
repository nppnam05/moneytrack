import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/budget.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/services/database_api.dart';

class AddBudgetScreen extends StatefulWidget {
  AddBudgetScreen({super.key, required this.title});

  final String title;

  @override
  _AddBudgetScreenState createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> with WidgetsBindingObserver {
  List<Categories> categories = [];

  // Controller cho các TextField
  final _amountController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  // Biến để lưu category được chọn
  Categories? _selectedCategory;
  int _userID = -1;
  List<Budget> budgets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // gọi dữ liệu lần đầu
    _loadData();

    DateTime now = DateTime.now();
    _monthController.text = now.month.toString();
    _yearController.text = now.year.toString();
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
                _selectedCategory = newValue;
              });
            },
            validator:
                (value) => value == null ? 'Vui lòng chọn danh mục' : null,
          ),
          const SizedBox(height: 16),
          TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Số tiền',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, // Hiển thị bàn phím số
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Chỉ cho phép số
              ],
            ),
          const SizedBox(height: 16),
          //  để nhập month
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Tháng',
              border: OutlineInputBorder(),
            ),
            value:
                _monthController.text.isNotEmpty
                    ? int.tryParse(_monthController.text)
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
                _monthController.text = value.toString();
              });
            },
          ),

          const SizedBox(height: 16),
          //  để nhập year
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Năm',
              border: OutlineInputBorder(),
            ),
            value:
                _yearController.text.isNotEmpty
                    ? int.tryParse(_yearController.text)
                    : null,
            items: List.generate(10, (index) {
              int year = DateTime.now().year - 8 + index;
              return DropdownMenuItem(value: year, child: Text('$year'));
            }),
            onChanged: (value) {
              setState(() {
                _yearController.text = value.toString();
              });
            },
          ),
          const SizedBox(height: 20),
          // Nút để thêm ngân sách
          ElevatedButton(
            onPressed: _addOrUpdateBudget,
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

  void _addOrUpdateBudget() {
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
    else if(_amountController.text[0] == "0"){
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('dữ liệu không hợp lệ')),
      );
      return;
    }

    // Tạo Budgets mới
    Budget newBudget = Budget(
      userId: _userID,
      categoryId: _selectedCategory!.id!,
      amount: double.parse(_amountController.text),
      month: int.parse(_monthController.text),
      year: int.parse(_yearController.text),
      createdAt:DateTime.now().millisecondsSinceEpoch, 
    );

    var budgetTemp = budgets.where((it) =>it.userId == _userID && it.categoryId == newBudget.categoryId && it.month == newBudget.month && it.year == newBudget.year).toList();
    if(budgetTemp.isNotEmpty){
      budgetTemp[0].amount += newBudget.amount;
      DatabaseApi.updateBudget(budgetTemp[0], onSuccess: (){print("update thanh cong");}, onError: (Error){});
    }
    else{
      DatabaseApi.insertBudget(newBudget, onSuccess: (){print("them thanh cong");}, onError: (Error){});
    }

    _selectedCategory = null;
    _amountController.clear();
    _monthController.clear();
    _yearController.clear();

    _loadData();
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
