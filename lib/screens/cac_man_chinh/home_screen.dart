import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/utils/database/database_api.dart';
import 'package:moneytrack/utils/show_notification.dart';
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
  Wallet wallet = Wallet(userId: 0, balance: 0);
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
                  style: TextStyle(
                    fontSize: 24,
                    color: (wallet.balance > 0) ? Colors.green : Colors.red,
                  ),
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

    // Gán icon và màu dựa theo category.id, nếu có thêm category mới thì tự sinh
    final iconList = [
      Icons.fastfood,
      Icons.home,
      Icons.shopping_bag,
      Icons.directions_car,
      Icons.movie,
      Icons.lightbulb,
      Icons.sports_soccer,
      Icons.school,
      Icons.local_hospital,
      Icons.flight,
      Icons.pets,
      Icons.cake,
      Icons.computer,
      Icons.phone_android,
      Icons.book,
      Icons.music_note,
      Icons.spa,
      Icons.beach_access,
      Icons.local_cafe,
      Icons.local_grocery_store,
      Icons.star,
    ];

    final colorList = [
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.blueGrey,
      Colors.teal,
      Colors.purple,
      Colors.green,
      Colors.redAccent,
      Colors.amber,
      Colors.indigo,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lime,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.yellow,
      Colors.blue,
      Colors.grey,
      Colors.black54,
    ];

    icon = iconList[category.id!];
    color = colorList[category.id!];

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
    var resultWallet = await DatabaseApi.getWalletsByUserId(0);
    wallet = resultWallet[0];

    var transaction = await DatabaseApi.getTransactionsByUserId(0);
    var resultBudgets = await DatabaseApi.getBudgetsByUserId(0);
    var resultCategory = await DatabaseApi.getAllCategories();

    // thoong báo nếu số dư ví âm
    showNotification();

    // Cập nhật số dư ví nếu tháng hiện tại lớn hơn tháng ngân sách
    var time = DateTime.now();
    for (var it in resultBudgets) {
      if (time.month - it.month == 1 &&
          time.year == it.year &&
          it.isDeducted == false) {
        resultWallet[0].balance -= it.amount;
        it.isDeducted = true;
        DatabaseApi.updateBudget(it, onSuccess: () {}, onError: (Error) {});
      }
    }

    DatabaseApi.updateWallet(
      resultWallet[0],
      onSuccess: () {},
      onError: (Error) {},
    );

    // khởi tạo các danh sách categories
    listCategory =
        resultCategory
            .map((it) => Categories(id: it.id, name: it.name, cost: 0))
            .toList();

    categoriesNganSach =
        resultCategory
            .map((it) => Categories(id: it.id, name: it.name, cost: 0))
            .toList();

    setState(() {
      // số dư ví
      balanceController.text = "${formatCurrency(resultWallet[0].balance)} VND";

      // danh sách chi tiêu theo thời gian
      var listTransaction;

      if (_selectedTime == TimeRange.month) {
        listTransaction =
            transaction.where((it) => isThisMonth(it.transactionDate)).toList();
      } else {
        listTransaction =
            transaction.where((it) => isThisWeek(it.transactionDate)).toList();
      }

      // Thu, Chi theo thời gian
      _tongThu = listTransaction
          .where((it) => it.type == "Thu")
          .fold(0.0, (sum, item) => sum + item.amount);
      _tongChi = listTransaction
          .where((it) => it.type == "Chi")
          .fold(0.0, (sum, item) => sum + item.amount);

      // danh sách chi tiêu theo danh mục
      listTransaction.forEach((it) {
        if (it.type == "Chi") {
          var cate = listCategory.firstWhere(
            (cate) => cate.id == it.categoryId,
            orElse: () => Categories(id: -1, name: '', cost: 0),
          );
          if (cate.id != -1) {
            cate.cost += it.amount;
          }
        }
      });

      listCategory.sort((a, b) => b.cost.compareTo(a.cost));
      // danh sách chi tiêu nhiều nhất
      listCategoryMax = listCategory.take(3).toList();
      categories = listCategory.sublist(3);

      // danh sách ngân sách theo tháng
      final now = DateTime.now();
      budgets =
          resultBudgets
              .where((it) => it.month == now.month && it.year == now.year)
              .toList();

      for (var it in budgets) {
        var cateTemp = categoriesNganSach.firstWhere(
          (cate) => cate.id == it.categoryId,
          orElse: () => Categories(id: -1, name: '', cost: 0),
        );
        cateTemp.cost += it.amount;
      }

      categoriesNganSach.sort((a, b) => b.cost.compareTo(a.cost));
    });
  }

  Future<void> showNotification() async {
    if (ShowNotification.hasShownWalletWarning == false && wallet.balance <= 0) {
      ShowNotification.hasShownWalletWarning = true;
      // thông báo nếu số dư ví âm
      if (wallet.balance <= -100) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'Cảnh báo ví âm',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(
                  'Số dư ví của bạn đang âm! Vui lòng nạp thêm tiền để tiếp tục sử dụng.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Đóng'),
                  ),
                ],
              ),
        );
      } else if (wallet.balance <= -10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Số dư ví của bạn đang âm! Vui lòng nạp thêm tiền.'),
            backgroundColor: Colors.red,
          ),
        );
      }


      // Hiển thị thông báo nếu ví hết tiền
      // Kiểm tra số dư ví, nếu hết tiền thì hiển thị thông báo
      await ShowNotification.showBudgetNotification(
        'Cảnh báo ví!',
        'Số dư ví của bạn đã hết. Vui lòng nạp thêm tiền để tiếp tục sử dụng.',
        0,
      );
    }
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
    if (decimalPart == "00") {
      return formattedWhole;
    }
    return '$formattedWhole,$decimalPart';
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

  bool isThisMonth(int timestamp) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return date.month == now.month && date.year == now.year;
  }
}
