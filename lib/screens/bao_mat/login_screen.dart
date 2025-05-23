import 'package:flutter/material.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/screens/bao_mat/verifycode_screen.dart';
import 'package:moneytrack/screens/screens.dart';
import 'package:moneytrack/utils/database/database_api.dart';
import 'package:collection/collection.dart';
import 'package:moneytrack/utils/email_otp.dart';
import '../../models/categories.dart';
import '../../models/transaction.dart';
import '../../models/budget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.title});

  final String title;
  static int userid = 0;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode forcus;

  var emailControllor = TextEditingController();
  var email_otp = EmailService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //themData();
    themCate();

    forcus = FocusNode();
  }

  Future<void> themCate() async {
     var listCate = await DatabaseApi.getAllCategories();
    if (listCate.isEmpty) {
      List<Categories> array = [
        Categories(id: 0, name: "Ăn uống", cost: 1000),
        Categories(id: 1, name: "Tiền thuê nhà", cost: 100),
        Categories(id: 2, name: "Mua sắm", cost: 50),
        Categories(id: 3, name: "Di chuyển", cost: 200),
        Categories(id: 4, name: "Giải trí", cost: 150),
        Categories(id: 5, name: "Hóa đơn tiện ích", cost: 80),
      ];

      array.forEach(
        (it) => DatabaseApi.insertCategory(
          it,
          onSuccess: () {},
          onError: (Error) {},
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    forcus.dispose();

    super.dispose();
  }

  void themData() {
    DateTime now = DateTime.now();
    DateTime mondayLastWeek = now.subtract(Duration(days: now.weekday + 6));
    int mondayLastWeekMillis = mondayLastWeek.millisecondsSinceEpoch;

    List<TransactionModel> transactions = [
      TransactionModel(
        userId: 0,
        categoryId: 0, // "Ăn uống"
        type: "Chi",
        amount: 500.0,
        description: "Bữa trưa",
        transactionDate:
            DateTime.now().millisecondsSinceEpoch, // Ví dụ về timestamp
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 1, // "Tiền thuê nhà"
        type: "Chi",
        amount: 100.0,
        description: "Thuê nhà tháng này",
        transactionDate: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 2, // "Mua sắm"
        type: "Chi",
        amount: 50.0,
        description: "Mua quần áo",
        transactionDate: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

    transactions.forEach(
      (it) => DatabaseApi.insertTransaction(
        it,
        onSuccess: () {
          print("Thêm giao dịch thành công");
        },
        onError: (Error) {},
      ),
    );

    List<Budget> budgets = [
      Budget(
        userId: 0,
        categoryId: 1,
        amount: 5000000,
        isDeducted: false,
        month: 5,
        year: 2025,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      Budget(
        userId: 0,
        categoryId: 2,
        amount: 3000000,
        isDeducted: false,
        month: 5,
        year: 2025,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      Budget(
        userId: 0,
        categoryId: 3,
        amount: 2000000,
        isDeducted: false,
        month: 5,
        year: 2025,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

    budgets.forEach(
      (it) => DatabaseApi.insertBudget(
        it,
        onSuccess: () {
          print("Thêm ngân sách thành công");
        },
        onError: (Error) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                90,
              ), // Bo tròn 90px (nửa chiều rộng/chiều cao để tạo hình tròn)
              child: Image.asset(
                "assets/images/logo.jpg",
                width: 180,
                height: 180,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailControllor,
              focusNode: forcus,
              decoration: InputDecoration(
                labelText: 'Email',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            dangNhap(),
          ],
        ),
      ),
    );
  }

  Widget dangNhap() {
    return ElevatedButton(
      onPressed: () {
        // logic kiểm tra

        _kiemTraUser();
      },
      child: Text('ĐĂNG NHẬP'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Future<void> _kiemTraUser() async {
    String email = emailControllor.text.trim();
    emailControllor.clear();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bạn chưa nhập đầy đủ thông tin')));
      return;
    }

    List<User> users = await DatabaseApi.getAllUsers();

    User? user = users.firstWhereOrNull((it) => it.email == email);

    if (user != null) {
      // lệnh gửi mã xác thực
      email_otp.guiMaOTP(email);
      print("$user");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  VerifyCodeScreen(title: "Xác thực", userID: user.id!),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email không tồn tại')));
      return;
    }
  }
}
