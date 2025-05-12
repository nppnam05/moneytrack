import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:moneytrack/services/database_api.dart';
import 'package:moneytrack/utils/load_total_cost.dart';

class UpdTransaction extends StatefulWidget {
  const UpdTransaction({super.key, required this.title});

  final String title;

  @override
  _UpdTransactionState createState() => _UpdTransactionState();
}

class _UpdTransactionState extends State<UpdTransaction>{
  List<TransactionModel > _transactions = [];
  List<Categories> _categories = [];

  // Danh sách loại giao dịch
  final List<String> _types = ['Thu', 'Chi'];

  // Biến để lưu trạng thái chỉnh sửa
  TransactionModel ? _editingTransaction;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
  Widget _itemTransaction(TransactionModel  transaction) {
    bool isEditing = _editingTransaction == transaction;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              transaction.type == 'Thu' ? Icons.arrow_downward : Icons.arrow_upward,
              color: transaction.type == 'Thu' ? Colors.green : Colors.red,
            ),
            title: Text("${transaction.amount.toStringAsFixed(2)} VNĐ"),
            subtitle: Text(
              "Danh mục: ${_categories[transaction.categoryId]}\n"
              "Ngày: ${DateTime.fromMillisecondsSinceEpoch(transaction.transactionDate).toString().substring(0, 10)}",
            ),
            onTap: () {
              setState(() {
                _editingTransaction = isEditing ? null : transaction; // nếu đã click trước đó thì trả về null
              });
            },
          ),
          if (isEditing) _buildEditForm(transaction),
        ],
      ),
    );
  }

  // Hàm tạo form chỉnh sửa
  Widget _buildEditForm(TransactionModel  transaction) {
    int selectedCategoryId = transaction.categoryId;
    String selectedType = transaction.type;
    TextEditingController amountController = TextEditingController(text: transaction.amount.toString());
    TextEditingController descriptionController = TextEditingController(text: transaction.description);
    DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(transaction.transactionDate);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DropdownButtonFormField cho danh mục
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: 'Danh mục',
              border: OutlineInputBorder(),
            ),
            value: selectedCategoryId,
            items: _categories.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.id,
                child: Text(entry.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategoryId = value!;
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
            value: selectedType,
            items: _types.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedType = value!;
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
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Ngày giao dịch',
                border: OutlineInputBorder(),
              ),
              child: Text(
                DateFormat('dd/MM/yyyy').format(selectedDate),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nút cập nhật và xóa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final updatedTransaction = TransactionModel(
                    id: transaction.id,
                    userId: transaction.userId,
                    categoryId: selectedCategoryId,
                    type: selectedType,
                    amount: double.parse(amountController.text),
                    description: descriptionController.text,
                    transactionDate: selectedDate.millisecondsSinceEpoch,
                    createdAt: transaction.createdAt,
                  );

                  // Chức năng cập nhật
                  await DatabaseApi.updateTransaction(
                    updatedTransaction,
                    onSuccess: () async {
                      await _loadData();
                      setState(() {
                        _editingTransaction = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cập nhật giao dịch thành công!')),
                      );
                      await UserUtils.syncUserRevenueAndExpenditure(updatedTransaction.userId);
                    },
                    onError: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi cập nhật giao dịch: $e')),
                      );
                    },
                  );
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

                      await UserUtils.syncUserRevenueAndExpenditure(transaction.userId);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Xoá giao dịch thành công!')),
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

  Future<void> _loadData() async {
  final categoriesFromDb = await DatabaseApi.getAllCategories();
  final transactionFromDb = await DatabaseApi.getAllTransactions();
  setState(() {
    _categories = categoriesFromDb;
    _transactions = transactionFromDb;
  });
  }

}