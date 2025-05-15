import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/services/database_api.dart';
import 'package:moneytrack/utils/load_total_cost.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key, required this.title});

  final String title;

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  // Danh sách danh mục
  List<Categories> _categories = [];
  List<TransactionModel> _transactionModel = [];
  int? _currentUserId;

  // Danh sách loại giao dịch
  final List<String> _types = ['Thu', 'Chi'];

  // Các controller và biến trạng thái
  int? _selectedCategoryId;
  String? _selectedType;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState(){
    super.initState();
    _loadData();
  }
  

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hàm lưu giao dịch
  void _saveTransaction() async {
  if (_selectedCategoryId == null ||
      _selectedType == null ||
      _amountController.text.isEmpty ||
      _descriptionController.text.isEmpty ||
      _selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
    );
    return;
  }

  final double amount = double.parse(_amountController.text);

  final newTransaction = TransactionModel(
    userId: _currentUserId!,
    categoryId: _selectedCategoryId!,
    type: _selectedType!,
    amount: amount,
    description: _descriptionController.text,
    transactionDate: _selectedDate!.millisecondsSinceEpoch,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  );


  // Thêm giao dịch
  await DatabaseApi.insertTransaction(
    newTransaction,
    onSuccess: () async {

      // Cập nhật lại ví
      await UserUtils.syncUserRevenueAndExpenditure(_currentUserId!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm giao dịch thành công!')),
      );

      setState(() {
        _selectedCategoryId = null;
        _selectedType = null;
        _amountController.clear();
        _descriptionController.clear();
        _selectedDate = null;
      });
    },
    onError: (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm giao dịch: $e')),
      );
    },
  );  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveTransaction),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DropdownButtonFormField cho danh mục
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Danh mục',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategoryId,
              items:
                  _categories.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.id,
                      child: Text(entry.name),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // DropdownButtonFormField cho loại giao dịch
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Loại giao dịch',
                border: OutlineInputBorder(),
              ),
              value: _selectedType,
              items:
                  _types.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // TextField cho số tiền
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Số tiền (VNĐ)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // TextField cho mô tả
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Chọn ngày giao dịch
            GestureDetector(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ngày giao dịch',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Chọn ngày'
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    final user = await DatabaseApi.getUserByEmail(LoginScreen.loggedInUserEmail!);
    if (user == null) return;

    final categoriesFromDb = await DatabaseApi.getAllCategories();
    final transactionFromDb = await DatabaseApi.getTransactionsByUserId(user.id!);
    
    setState(() {
      _currentUserId = user.id;
      _categories = categoriesFromDb;
      _transactionModel = transactionFromDb;
    });
  }
}
