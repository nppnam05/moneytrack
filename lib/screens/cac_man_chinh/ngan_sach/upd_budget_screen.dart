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
  List<Wallet> wallets = [];

  // Danh sách category giả lập để hiển thị tên danh mục
  List<Categories> _categories = [];

  // Biến để lưu trạng thái chỉnh sửa
  Budget? _editingBudget;
  int _userID = -1;


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
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          //  để nhập month
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Tháng',
              border: OutlineInputBorder(),
            ),
            value: budget.month,
            items: List.generate(12, (index) {
              int month = index + 1;
              return DropdownMenuItem(
                value: month,
                child: Text('Tháng $month'),
              );
            }),
            onChanged: (value) {
              setState(() {
               budget.month = value!;
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
            value: budget.year,
            items: List.generate(10, (index) {
              int year = DateTime.now().year - 8 + index;
              return DropdownMenuItem(value: year, child: Text('$year'));
            }),
            onChanged: (value) {
              setState(() {
                budget.year = value!; 
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

                  _updateBudget(
                    budget,
                    newAmount
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
              'Danh mục: ${index + 1} ${_categories[budget.categoryId].name ?? 'Không xác định'}',
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
  ) {
    // Kiểm tra số dư trong ví
    double totalAmount = budgets.fold(0.0, (sum, budget) {return sum + budget.amount;});
    totalAmount -= budget.amount;
    totalAmount += newAmount;
    if(wallets[0].balance < totalAmount){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số dư trong ví không đủ')),
      );
      return;
    }
    

    var budgetTemp =
        budgets
            .where(
              (it) =>
                  it.year == budget.year &&
                  it.month == budget.month &&
                  it.categoryId == budget.categoryId &&
                  it.id != budget.id,
            )
            .toList();

    if (budgetTemp.isNotEmpty) {
      setState(() {
        budgetTemp[0].amount += newAmount;
        budgets.remove(budget);
      });
      DatabaseApi.updateBudget(
        budgetTemp[0],
        onSuccess: () {
          debugPrint("Update thanh cong");
        },
        onError: (error) {},
      );
      DatabaseApi.deleteBudget(
        budget,
        onSuccess: () {
          debugPrint("Xoa thanh cong");
        },
        onError: (Error) {},
      );
    } else {
      setState(() {
        budget.amount = newAmount;
        _editingBudget = null; // Đóng form chỉnh sửa sau khi cập nhật
      });
      DatabaseApi.updateBudget(
        budget,
        onSuccess: () {
          debugPrint("Update thanh cong");
        },
        onError: (Error) {},
      );
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật ngân sách')));
  }

  Future<void> _loadData() async {
    _userID = LoginScreen.userid;

    _categories.clear();
    budgets.clear();
    wallets.clear();

    var resultCategory = await DatabaseApi.getAllCategories();
    var resultBudget = await DatabaseApi.getBudgetsByUserId(_userID);
    var resultWallet = await DatabaseApi.getWalletsByUserId(_userID);

    setState(() {
      _categories.addAll(resultCategory);
      budgets.addAll(resultBudget);
      wallets.addAll(resultWallet);
    });
  }
}
