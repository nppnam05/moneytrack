import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import 'package:moneytrack/utils/database/database_api.dart';
import '../../models/budget.dart';
import '../../widgets/chi_tieu_pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum TimeRange { week, month }

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TimeRange _selectedTime = TimeRange.week;

  final balanceController = TextEditingController(text: '0 đ');
  User? user = null;

  List<Categories> categories = [];
  List<Categories> listCategory = [];
  List<Categories> listCategoryMax = [];
  List<Categories> categoriesNganSach = [];

  List<Budget> budgets = [];
  double _tongThu = 0;
  double _tongChi = 0;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tienMat(),
            const SizedBox(height: 10),
            _radioThoiGian(),
            const SizedBox(height: 10),
            _tongThuChi(), // tổng thu, chi
            const SizedBox(height: 10),
            ChiTieuPieChart(categories: listCategory),
            const SizedBox(height: 10),
            Text(
              'Chi tiêu nhiều nhất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _itemListChiTieu(listCategoryMax),
            Text(
              'Các khoản chi tiêu khác',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _itemListChiTieu(categories),
            const SizedBox(height: 10),
            const Text(
              'Danh sách ngân sách tháng này',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _itemListChiTieu(categoriesNganSach), // danh sách ngân sách
          ],
        ),
      ),
    );
  }

  // Hàm tính và hiển thị tổng thu nhập
  Widget _tongThuChi() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng thu nhập:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${formatCurrency(_tongThu)} VNĐ',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng chi tiêu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${formatCurrency(_tongChi)} VNĐ',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // RadioListTile chọn thời gian
  Widget _radioThoiGian() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          RadioListTile<TimeRange>(
            title: const Text('Tuần'),
            value: TimeRange.week,
            groupValue: _selectedTime,
            onChanged: (value) {
              _selectedTime = value!;
              _loadData();
            },
          ),
          RadioListTile<TimeRange>(
            title: const Text('Tháng'),
            value: TimeRange.month,
            groupValue: _selectedTime,
            onChanged: (value) {
              _selectedTime = value!;
              _loadData();
            },
          ),
        ],
      ),
    );
  }

  // Tiền mặt
  Widget _tienMat() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[300],
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tiền mặt',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: balanceController,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24, color: Colors.green),
                  decoration: const InputDecoration.collapsed(hintText: ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Danh sách chi tiêu
  Widget _itemListChiTieu(List<Categories> Category) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Category.length,
      itemBuilder: (context, index) {
        final categoryStatic = Category[index];

        if (categoryStatic.cost != 0) {
          return _createItemChiTieu(categoryStatic);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _createItemChiTieu(Categories category) {
    IconData icon;
    Color color;

    // Gán icon và màu dựa theo danh mục
    switch (category.id) {
      case 0:
        icon = Icons.fastfood;
        color = Colors.pinkAccent;
        break;
      case 1:
        icon = Icons.home;
        color = Colors.orangeAccent;
        break;
      case 2:
        icon = Icons.shopping_bag;
        color = Colors.blueGrey;
        break;
      case 3:
        icon = Icons.directions_car;
        color = Colors.teal;
        break;
      case 4:
        icon = Icons.movie;
        color = Colors.purple;
        break;
      case 5:
        icon = Icons.lightbulb;
        color = Colors.green;
        break;
      default:
        icon = Icons.category;
        color = Colors.grey;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(category.name),
      trailing: Text(
        '${formatCurrency(category.cost)} VND',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  Future<void> _loadData() async {
    int userID = LoginScreen.userid;

    var resultUser = await DatabaseApi.getUserById(userID);
    var resultWallet = await DatabaseApi.getWalletsByUserId(userID);

    var transaction = await DatabaseApi.getTransactionsByUserId(userID);
    var resultBudgets = await DatabaseApi.getBudgetsByUserId(userID);

    setState(() {
      user = resultUser;
      balanceController.text = "${formatCurrency(resultWallet[0].balance)} VND";

      listCategory = [
        Categories(id: 0, name: "Ăn uống", cost: 0),
        Categories(id: 1, name: "Tiền thuê nhà", cost: 0),
        Categories(id: 2, name: "Mua sắm", cost: 0),
        Categories(id: 3, name: "Di chuyển", cost: 0),
        Categories(id: 4, name: "Giải trí", cost: 0),
        Categories(id: 5, name: "Hóa đơn tiện ích", cost: 0),
      ];

      categoriesNganSach = [
        Categories(id: 0, name: "Ăn uống", cost: 0),
        Categories(id: 1, name: "Tiền thuê nhà", cost: 0),
        Categories(id: 2, name: "Mua sắm", cost: 0),
        Categories(id: 3, name: "Di chuyển", cost: 0),
        Categories(id: 4, name: "Giải trí", cost: 0),
        Categories(id: 5, name: "Hóa đơn tiện ích", cost: 0),
      ];

      var listTransaction;
      budgets.clear();

      if (_selectedTime == TimeRange.month) {
        listTransaction =
            transaction.where((it) => isThisMonth(it.transactionDate)).toList();
      } else {
        listTransaction =
            transaction.where((it) => isThisWeek(it.transactionDate)).toList();
      }

      _tongThu = listTransaction
          .where((it) => it.type == "Thu")
          .fold(0.0, (sum, item) => sum + item.amount);
      _tongChi = listTransaction
          .where((it) => it.type == "Chi")
          .fold(0.0, (sum, item) => sum + item.amount);

      listTransaction.forEach((it) {
        listCategory[it.categoryId].cost += it.amount;
      });

      listCategory.sort((a, b) => b.cost.compareTo(a.cost));
      listCategoryMax = listCategory.take(3).toList();
      categories = listCategory.sublist(3);

      final now = DateTime.now();
      budgets =
          resultBudgets
              .where((it) => it.month == now.month && it.year == now.year)
              .toList();

      for (var it in budgets) {
        categoriesNganSach[it.categoryId].cost += it.amount;
      }
      
      categoriesNganSach.sort((a, b) => b.cost.compareTo(a.cost));
    });
  }

  // định dạng tiền
  String formatCurrency(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final wholePart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    int count = 0;

    for (int i = wholePart.length - 1; i >= 0; --i) {
      buffer.write(wholePart[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    final formattedWhole = buffer.toString().split('').reversed.join();
    if(decimalPart == "00"){
      return formattedWhole;
    }
    return '$formattedWhole,$decimalPart';
  }

  bool isThisWeek(int timestamp) {
    final now = DateTime.now();

    // Tính ngày đầu tuần (Thứ Hai)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    // Ngày cuối tuần 
    final end = start
        .add(const Duration(days: 7))
        .subtract(const Duration(milliseconds: 1));

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return !date.isBefore(start) && !date.isAfter(end);
  }

  bool isThisMonth(int timestamp) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return date.month == now.month && date.year == now.year;
  }
}