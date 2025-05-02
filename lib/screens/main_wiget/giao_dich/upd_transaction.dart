import 'package:flutter/material.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:intl/intl.dart';

class UpdTransaction extends StatefulWidget {
  const UpdTransaction({super.key, required this.title});

  final String title;

  @override
  _UpdTransactionState createState() => _UpdTransactionState();
}

class _UpdTransactionState extends State<UpdTransaction> {
  // Giả lập danh sách giao dịch (trong thực tế, bạn có thể lấy từ SQLite)
  final List<Transaction> _transactions = [
    Transaction(1, 1, 1, 'Chi', 200000, 'Mua đồ ăn', DateTime(2025, 5, 1).millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch),
    Transaction(2, 1, 2, 'Chi', 1000000, 'Mua quần áo', DateTime(2025, 5, 2).millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch),
    Transaction(3, 1, 5, 'Thu', 5000000, 'Lương tháng', DateTime(2025, 5, 3).millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch),
  ];

  // Danh sách danh mục (giả lập)
  final Map<int, String> _categories = {
    1: 'Food',
    2: 'Shopping',
    3: 'Rental',
  };

  // Danh sách loại giao dịch
  final List<String> _types = ['Thu', 'Chi'];

  // Biến để lưu trạng thái chỉnh sửa
  Transaction? _editingTransaction;

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
  Widget _itemTransaction(Transaction transaction) {
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
              "Danh mục: ${_categories[transaction.category_id]}\n"
              "Ngày: ${DateTime.fromMillisecondsSinceEpoch(transaction.transaction_date).toString().substring(0, 10)}",
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
  Widget _buildEditForm(Transaction transaction) {
    int selectedCategoryId = transaction.category_id;
    String selectedType = transaction.type;
    TextEditingController amountController = TextEditingController(text: transaction.amount.toString());
    TextEditingController descriptionController = TextEditingController(text: transaction.description);
    DateTime selectedDate = DateTime.fromMillisecondsSinceEpoch(transaction.transaction_date);

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
            items: _categories.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
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
                onPressed: () {
                  // Cập nhật giao dịch
                  final updatedTransaction = Transaction(
                    transaction.id,
                    transaction.user_id,
                    selectedCategoryId!,
                    selectedType,
                    double.parse(amountController.text),
                    descriptionController.text,
                    selectedDate.millisecondsSinceEpoch,
                    transaction.created_at,
                  );

                  setState(() {
                    _transactions[_transactions.indexOf(transaction)] = updatedTransaction;
                    _editingTransaction = null;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật giao dịch thành công!')),
                  );
                },
                child: const Text('Cập nhật'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Xóa giao dịch
                  setState(() {
                    _transactions.remove(transaction);
                    _editingTransaction = null;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xóa giao dịch thành công!')),
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

}