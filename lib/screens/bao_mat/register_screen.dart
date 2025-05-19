import 'package:flutter/material.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/utils/database/database_api.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, required this.title});

  final String title;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkUsers();
  }

  void _checkUsers() async {
    var users = await DatabaseApi.getAllUsers();
    if (users.isNotEmpty) {
       Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Chúng tôi sẽ không đăng thông tin mà không có sự cho phép của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Họ tên',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // logic đăng ký
                _dangKy();

              },
              child: Text('ĐĂNG KÝ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _dangKy() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    if(name.isEmpty || email.isEmpty){
       ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bạn chưa nhập đầy đủ thông tin')));
      return;
    }

    User newUser = User(
      id: 0,
      name: name,
      email: email,
      totalExpenditure: 0.0,
      totalRevenue: 0.0,
    );

    int userId = await DatabaseApi.insertUser(
      newUser,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công')),
        );

         Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      },
      onError: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: $e')),
        );
      },
    );

    // Tạo ví mặc định cho người dùng mới
    Wallet defaultWallet = Wallet(
      userId: userId,
      balance: 0.0,
    );
    await DatabaseApi.insertWallet(
      defaultWallet,
      onSuccess: () {},
      onError: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo ví thất bại: $e')),
        );
      },
    );

  }
}
