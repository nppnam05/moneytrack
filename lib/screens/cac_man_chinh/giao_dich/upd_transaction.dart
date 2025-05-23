import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:intl/intl.dart';
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
  List<TransactionModel> listTuan = [];
  List<TransactionModel> listThang = [];
  List<List<TransactionModel>> listTungThang = [];
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách giao dịch Tuần này',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            _buildTransactionList(listTuan),
            const SizedBox(height: 10),
            Text(
              'Danh sách giao dịch Tháng',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            _builListTheoThang(),
          ],
        ),
      ),
    );
  }

  Widget _builListTheoThang(){
    if(listTungThang.isEmpty) {
      return const Center(
        child: Text("Không có giao dịch nào trong tháng này"),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listTungThang.length,
      itemBuilder: (context, index) {
        if (listTungThang[index].isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Text(
              'Tháng ${DateTime.fromMillisecondsSinceEpoch(listTungThang[index][0].transactionDate).month}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTransactionList(listTungThang[index]),
          ],
        );
      },
    );
  }

  // Hàm tạo ListView
  Widget _buildTransactionList(List<TransactionModel> transactions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return _itemTransaction(transactions[index]);
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
              "Danh mục: ${_categories.firstWhere((cate) => cate.id == transaction.categoryId, orElse: () => Categories(id: -1, name: 'Không xác định', cost: 0.0)).name}\n"
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
            items: _categories.map((category) {
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
            items: _types.map((type) {
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

          // TextFormField cho số tiền readOnly
          TextFormField(
            initialValue: transaction.amount.toString(),
            decoration: const InputDecoration(
              labelText: 'Số tiền (VNĐ)',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
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

          // Nút cập nhật ra giữa
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  _selectedType = null;
                  _selectedDate = null;
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Cập nhật'),
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
    // Cập nhật lại tổng thu/chi Wallet
    var walletsList = await DatabaseApi.getWalletsByUserId(transaction.userId);
    var wallet = walletsList[0];

    if (type == 'Chi') {
      wallet.balance -= amount;
    } else {
      wallet.balance += amount;
    }

    await DatabaseApi.updateWallet(
      wallet,
      onSuccess: () {
        print("Cập nhật số dư ví thành công");
      },
      onError: (e) {
        print("Lỗi khi cập nhật ví: $e");
      },
    );

    setState(() {
      // Cập nhật thông tin giao dịch
      transaction.description = desc;
      transaction.transactionDate = selectedDate.millisecondsSinceEpoch;
      transaction.type = type;
      // đóng form chỉnh sửa
      _editingTransaction = null;
    });

    // Cập nhật giao dịch trong cơ sở dữ liệu
    DatabaseApi.updateTransaction(
      transaction,
      onSuccess: () {},
      onError: (e) {},
    );
  }

  Future<void> _loadData() async {
    // Lấy danh sách từ cơ sở dữ liệu
    var categoriesFromDb = await DatabaseApi.getAllCategories();
    var transactionFromDb = await DatabaseApi.getTransactionsByUserId(0);

    transactionFromDb.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });

    setState(() {
      _categories = categoriesFromDb;
      listTuan =
          transactionFromDb
              .where((transaction) => isThisWeek(transaction.transactionDate))
              .toList();
    });
    listThang =
        transactionFromDb
            .where((transaction) => !isThisWeek(transaction.transactionDate))
            .toList();

    var time = DateTime.now();
    for(int i = time.month; i > 0; --i) {
      var list = listThang
          .where((transaction) => DateTime.fromMillisecondsSinceEpoch(transaction.transactionDate).month == i)
          .toList();
      listTungThang.add(list);
    }
  }

  bool isThisWeek(int timestamp) {
    final now = DateTime.now();

    // Tính ngày đầu tuần (Thứ Hai)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    // Ngày cuối tuần
    final end = start
        .add(const Duration(days: 7))
        .subtract(const Duration(milliseconds: 1));

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return !date.isBefore(start) && !date.isAfter(end);
  }
}
