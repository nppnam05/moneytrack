import 'package:flutter/material.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/models/wallet.dart';
import 'package:moneytrack/services/database_api.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, required this.title});

  final String title;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: UnderlineInputBorder(),
                suffixIcon: Icon(Icons.visibility),
              ),
            ),
            SizedBox(height: 20),
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
    String password = passwordController.text.trim();

    if(name.isEmpty || email.isEmpty || password.isEmpty){
       ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bạn chưa nhập đầy đủ thông tin')));
      return;
    }

    List<User> users = await DatabaseApi.getAllUsers();

    bool checkEmail = users.any((it) => it.email == email);
    bool checkUser = users.any((it) => it.name == name && it.password == password);
    if (checkEmail) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email đã tồn tại')));
      return;
    } else if (checkUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password hoặc UserName đã tồn tại')),
      );
      return;
    }

    User newUser = User(
      name: name,
      email: email,
      password: password,
      totalExpenditure: 0.0,
      totalRevenue: 0.0,
    );

    int userId = await DatabaseApi.insertUser(
      newUser,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công')),
        );

        Navigator.pop(context); // Quay lại màn hình trước
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
