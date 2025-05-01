import 'package:flutter/material.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key, required this.title});

  final String title;

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  // Giả lập danh sách danh mục (trong thực tế, bạn có thể lấy từ SQLite hoặc Provider)
  final Map<int, String> _categories = {
    1: 'Ăn uống',
    2: 'Mua sắm',
    3: 'Di chuyển',
    4: 'Giải trí',
    5: 'Thu nhập',
  };

  // Danh sách loại giao dịch
  final List<String> _types = ['Thu', 'Chi'];

  // Các controller và biến trạng thái
  int? _selectedCategoryId;
  String? _selectedType;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

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
  void _saveTransaction() {
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

    final newTransaction = Transaction(
      0, // ID sẽ được tạo tự động bởi SQLite
      1, // user_id giả lập là 1
      _selectedCategoryId!,
      _selectedType!.toLowerCase() == 'thu' ? 'income' : 'expense',
      double.parse(_amountController.text),
      _descriptionController.text,
      _selectedDate!.millisecondsSinceEpoch, // transaction_date
      DateTime.now().millisecondsSinceEpoch, // created_at
    );

    // In thông tin giao dịch (trong thực tế, bạn sẽ lưu vào SQLite)
    print('New Transaction: id=${newTransaction.id}, '
        'user_id=${newTransaction.user_id}, '
        'category_id=${newTransaction.category_id}, '
        'type=${newTransaction.type}, '
        'amount=${newTransaction.amount}, '
        'description=${newTransaction.description}, '
        'transaction_date=${newTransaction.transaction_date}, '
        'created_at=${newTransaction.created_at}');

    // Hiển thị thông báo thành công và quay lại
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thêm giao dịch thành công!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTransaction,
          ),
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
              items: _categories.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Vui lòng chọn danh mục' : null,
            ),
            const SizedBox(height: 16),

            // DropdownButtonFormField cho loại giao dịch
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Loại giao dịch',
                border: OutlineInputBorder(),
              ),
              value: _selectedType,
              items: _types.map((type) {
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
              validator: (value) =>
                  value == null ? 'Vui lòng chọn loại giao dịch' : null,
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

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
