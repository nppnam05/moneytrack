import 'package:flutter/material.dart';
import 'package:moneytrack/models/budget.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/utils/database/database_api.dart';

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
  List<Budget> _budgets = [];
  int _userId = 0;

  // Danh sách loại giao dịch
  final List<String> _types = ['Thu', 'Chi'];

  // Các controller và biến trạng thái
  int? _selectedCategoryId;
  String? _selectedType;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
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
      userId: _userId,
      categoryId: _selectedCategoryId!,
      type: _selectedType!,
      amount: amount,
      description: _descriptionController.text,
      transactionDate: _selectedDate!.millisecondsSinceEpoch,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    // Kiểm tra số tiền có lớn hơn ngân sách không nếu là chi
    Budget? budgets =
        _budgets
            .where(
              (budget) =>
                  budget.categoryId == _selectedCategoryId &&
                  budget.userId == _userId,
            )
            .firstOrNull;

    if (budgets != null) {
      if (_selectedType == 'Chi') {
        if (amount > budgets.amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Số tiền vượt quá ngân sách tháng này!'),
            ),
          );
          return;
        }
        else{
          budgets.amount = budgets.amount - amount;
          DatabaseApi.updateBudget(
            budgets,
            onSuccess: () {},
            onError: (e) {},
          );
        }
      }
    }

    // cập nhập wallet
    var wallets = await DatabaseApi.getWalletsByUserId(_userId);
    var wallet = wallets[0];

    if (newTransaction.type == 'Chi') {
      // kiểm tra số dư ví có đủ không
      if (wallet.balance < newTransaction.amount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Số dư ví không đủ!')),
        );
        return;
      }
      
      wallet.balance = wallet.balance - newTransaction.amount;
    } else {
      wallet.balance = wallet.balance + newTransaction.amount;
    }

    DatabaseApi.updateWallet(
      wallet,
      onSuccess: () {
        print('Cập nhật thành công');
      },
      onError: (e) {
        print('Lỗi khi cập nhật: $e');
      },
    );

    // Thêm giao dịch
    await DatabaseApi.insertTransaction(
      newTransaction,
      onSuccess: () async {
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi thêm giao dịch: $e')));
      },
    );


  }


  Future<void> _loadData() async {
    int id_user = LoginScreen.userid;

    final categoriesFromDb = await DatabaseApi.getAllCategories();
    final transactionFromDb = await DatabaseApi.getTransactionsByUserId(
      id_user,
    );
    final budgetsFromDb = await DatabaseApi.getBudgetsByUserId(id_user);

    setState(() {
      _userId = id_user;
      _categories = categoriesFromDb;
      _transactionModel = transactionFromDb;
      _budgets = budgetsFromDb;
    });
  }
}
