import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/utils/database/database_api.dart';

class UpdTransaction extends StatefulWidget {
  const UpdTransaction({super.key, required this.title});

  final String title;

  @override
  _UpdTransactionState createState() => _UpdTransactionState();
}

class _UpdTransactionState extends State<UpdTransaction> {
  List<TransactionModel> _transactions = [];
  List<Categories> _categories = [];
  DateTime? _selectedDate;

  // Danh sách loại giao dịch
  final List<String> _types = ['Thu', 'Chi'];

  // Biến để lưu trạng thái chỉnh sửa
  TransactionModel? _editingTransaction;

  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildTransactionList(),
    );
  }

  // Hàm tạo ListView
  Widget _buildTransactionList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        return _itemTransaction(_transactions[index]);
      },
    );
  }

  // Hàm tạo item trong ListView
  Widget _itemTransaction(TransactionModel transaction) {
    bool isEditing = _editingTransaction == transaction;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              transaction.type == 'Thu'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: transaction.type == 'Thu' ? Colors.green : Colors.red,
            ),
            title: Text("${transaction.amount.toStringAsFixed(2)} VNĐ"),
            subtitle: Text(
              "Danh mục: ${_categories[transaction.categoryId]}\n"
              "Ngày: ${DateTime.fromMillisecondsSinceEpoch(transaction.transactionDate).toString().substring(0, 10)}",
            ),
            onTap: () {
              setState(() {
                _editingTransaction =
                    isEditing
                        ? null
                        : transaction; // nếu đã click trước đó thì trả về null
              });
            },
          ),
          if (isEditing) _buildEditForm(transaction),
        ],
      ),
    );
  }

  // Hàm tạo form chỉnh sửa
  Widget _buildEditForm(TransactionModel transaction) {
    String _selectedTypeIndex = transaction.type;
    TextEditingController amountController = TextEditingController(
      text: transaction.amount.toString(),
    );
    TextEditingController descriptionController = TextEditingController(
      text: transaction.description,
    );
    DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(
      transaction.transactionDate,
    );

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown để chọn category
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Danh mục',
              border: OutlineInputBorder(),
            ),
            value: transaction.categoryId,
            items:
                _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
            onChanged: (newValue) {
              setState(() {
                transaction.categoryId = newValue!;
              });
            },
          ),
          SizedBox(height: 16),

          // DropdownButtonFormField cho loại giao dịch
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Loại giao dịch',
              border: OutlineInputBorder(),
            ),
            value: _selectedTypeIndex,
            items:
                _types.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTypeIndex = value!;
                _selectedType = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          // TextField cho số tiền
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Số tiền (VNĐ)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // TextField cho mô tả
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Mô tả',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Chọn ngày giao dịch
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                  selectedDate = picked;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Ngày giao dịch',
                border: OutlineInputBorder(),
              ),
              child: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
            ),
          ),
          const SizedBox(height: 16),

          // Nút cập nhật và xóa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _updateTransaction(
                    transaction,
                    double.parse(amountController.text),
                    descriptionController.text,
                    _selectedDate ?? selectedDate,
                    _selectedType ?? _selectedTypeIndex,
                  );
                  // xets lại giá trị
                  _selectedType = null;
                  _selectedDate = null;
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Cập nhật'),
              ),

              ElevatedButton(
                onPressed: () async {
                  // chức năng xoá
                  await DatabaseApi.deleteTransaction(
                    transaction,
                    onSuccess: () async {
                      setState(() {
                        _transactions.remove(transaction);
                        _editingTransaction = null;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Xoá giao dịch thành công!'),
                        ),
                      );
                    },
                    onError: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi xoá giao dịch: $e')),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateTransaction(
    TransactionModel transaction,
    double amount,
    String desc,
    DateTime selectedDate,
    String type,
  ) async {
    // xét các trương hợp cập nhật lại
    var totalTH = 0.0;

    if (type == transaction.type) {
      if (type == "Chi") {
        totalTH += transaction.amount;
        totalTH -= amount;
      } else {
        totalTH -= transaction.amount;
        totalTH += amount;
      }
    } else {
      if (type == "Chi") {
        totalTH -= transaction.amount;
        totalTH -= amount;
      } else {
        totalTH += transaction.amount;
        totalTH += amount;
      }
    }


    // Cập nhật lại tổng thu/chi Wallet
    var walletsList = await DatabaseApi.getWalletsByUserId(transaction.userId);
    var wallet = walletsList[0];

    // kiểm tra số dư ví có đủ không
    if (wallet.balance < totalTH * -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Số dư ví không đủ!')));
      return;
    }

    wallet.balance += totalTH;

    await DatabaseApi.updateWallet(
      wallet,
      onSuccess: () {
        print("Cập nhật số dư ví thành công");
      },
      onError: (e) {
        print("Lỗi khi cập nhật ví: $e");
      },
    );

    // cập nhập ngân sách nếu có
    var budgetsList = await DatabaseApi.getBudgetsByUserId(transaction.userId);
    var budget =
        budgetsList
            .where((budget) => budget.categoryId == transaction.categoryId)
            .firstOrNull;

    if (budget != null) {
      budget.amount += totalTH;

      DatabaseApi.updateBudget(budget, onSuccess: () {}, onError: (e) {});
    }


    setState(() {
      // Cập nhật thông tin giao dịch
      transaction.amount = amount;
      transaction.description = desc;
      transaction.transactionDate = selectedDate.millisecondsSinceEpoch;
      transaction.type = type;
      // đóng form chỉnh sửa
      _editingTransaction = null;
    });

    // Cập nhật giao dịch trong cơ sở dữ liệu
    DatabaseApi.updateTransaction(
      transaction,
      onSuccess: () {
        print("Cập nhật giao dịch thành công");
      },
      onError: (e) {
        print("Lỗi khi cập nhật giao dịch: $e");
      },
    );
  }

  Future<void> _loadData() async {
    int id_user = LoginScreen.userid;

    _categories.clear();
    _transactions.clear();
    // Lấy danh sách từ cơ sở dữ liệu
    final categoriesFromDb = await DatabaseApi.getAllCategories();
    final transactionFromDb = await DatabaseApi.getTransactionsByUserId(
      id_user,
    );

    setState(() {
      _categories = categoriesFromDb;
      _transactions = transactionFromDb;
    });
  }
}
