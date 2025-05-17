import 'package:flutter/material.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/screens/screens.dart';
import 'package:moneytrack/utils/database/database_api.dart';
import 'package:collection/collection.dart';
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

  var dangKy = RegisterScreen(title: "Đăng ký");
  var quenMatKhau = ForgotPasswordScreen(title: "Quên mật khẩu");

  var emailControllor = TextEditingController();
  var passwordControllor = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themData();

    forcus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    forcus.dispose();

    super.dispose();
  }

  void themData() {
    // DatabaseApi.insertUser(User(id: 0, name: "Nam", email: "nppnam05@gmail.com", password: "a", totalExpenditure: 0, totalRevenue: 0), onSuccess: (){}, onError: (Error){});
    // DatabaseApi.insertWallet(Wallet(id: 0, userId: 0, balance: 1000), onSuccess: (){}, onError: (Error){});

    List <Categories> array = [
      Categories(id: 0, name: "Ăn uống", cost: 1000),
      Categories(id: 1, name: "Tiền thuê nhà", cost: 100),
      Categories(id: 2, name: "Mua sắm", cost: 50),
      Categories(id: 3, name: "Di chuyển", cost: 200),
      Categories(id: 4, name: "Giải trí", cost: 150),
      Categories(id: 5, name: "Hóa đơn tiện ích", cost: 80),
    ];

    // array.forEach((it) =>
    // DatabaseApi.insertCategory(it, onSuccess: (){}, onError: (Error){})
    // );

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
        transactionDate: 1623675623000, // Ví dụ về timestamp
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 1, // "Tiền thuê nhà"
        type: "Chi",
        amount: 100.0,
        description: "Thuê nhà tháng này",
        transactionDate: 1623675623000,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 2, // "Mua sắm"
        type: "Chi",
        amount: 50.0,
        description: "Mua quần áo",
        transactionDate: 1623675623000,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 3, // "Di chuyển"
        type: "Chi",
        amount: 200.0,
        description: "Di chuyển bằng taxi",
        transactionDate: 1623675623000,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 4, // "Giải trí"
        type: "Chi",
        amount: 150.0,
        description: "Đi xem phim",
        transactionDate: 1623675623000,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 0, // "Ăn uống"
        type: "Chi",
        amount: 100.0,
        description: "Bữa trưa",
        transactionDate: 1623675623000, // Ví dụ về timestamp
        createdAt: mondayLastWeekMillis,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 1, // "Tiền thuê nhà"
        type: "Chi",
        amount: 100.0,
        description: "Thuê nhà tháng này",
        transactionDate: 1623675623000,
        createdAt: mondayLastWeekMillis,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 2, // "Mua sắm"
        type: "Chi",
        amount: 500.0,
        description: "Mua quần áo",
        transactionDate: 1623675623000,
        createdAt: mondayLastWeekMillis,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 3, // "Di chuyển"
        type: "Chi",
        amount: 300.0,
        description: "Di chuyển bằng taxi",
        transactionDate: 1623675623000,
        createdAt: mondayLastWeekMillis,
      ),
      TransactionModel(
        userId: 0,
        categoryId: 4, // "Giải trí"
        type: "Chi",
        amount: 200.0,
        description: "Đi xem phim",
        transactionDate: 1623675623000,
        createdAt: mondayLastWeekMillis,
      ),
    ];

    // transactions.forEach((it) => DatabaseApi.insertTransaction(it, onSuccess: (){}, onError: (Error){}));


    List<Budget> budgets = [
      Budget(
        
        userId: 0,
        categoryId: 1,
        amount: 5000000,
        month: 5,
        year: 2025,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      Budget(
       
        userId: 0,
        categoryId: 2,
        amount: 3000000,
        month: 5,
        year: 2025,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      Budget(
        
        userId: 0,
        categoryId: 3,
        amount: 2000000,
        month: 5,
        year: 2025,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

    // budgets.forEach((it) => DatabaseApi.insertBudget(it, onSuccess: (){}, onError: (Error){}));
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
            SizedBox(height: 10),
            TextField(
              controller: passwordControllor,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: UnderlineInputBorder(),
                suffixIcon: Icon(Icons.visibility),
              ),
            ),
            SizedBox(height: 20),
            dangNhap(),
            SizedBox(height: 10),
            dangKyVaQuenMK(),
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

  Widget dangKyVaQuenMK() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            // đăng ký
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => dangKy),
            );
          },
          child: Text('Đăng ký'),
        ),
        TextButton(
          onPressed: () {
            // quên mật khẩu
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => quenMatKhau),
            );
          },
          child: Text('Quên mật khẩu?'),
        ),
      ],
    );
  }

  Future<void> _kiemTraUser() async {
    String email = emailControllor.text.trim();
    String password = passwordControllor.text.trim();
    emailControllor.clear();
    passwordControllor.clear();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bạn chưa nhập đầy đủ thông tin')));
      return;
    }

    List<User> users = await DatabaseApi.getAllUsers();

    User? user = users.firstWhereOrNull(
      (it) => it.email == email && it.password == password,
    );

    if (user != null) {
      LoginScreen.userid = user.id!;
      Navigator.pushReplacementNamed(context, '/main_manager');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tài khoản không tồn tại ')));
      return;
    }
  }
}
