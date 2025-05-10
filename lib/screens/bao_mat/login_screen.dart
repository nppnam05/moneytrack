import 'package:flutter/material.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/screens/screens.dart';
import 'package:moneytrack/services/database_api.dart';
import 'package:collection/collection.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.title});

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode forcus;

  static int userid = -1;
  var dangKy = RegisterScreen(title: "Đăng ký");
  var quenMatKhau = ForgotPasswordScreen(title: "Quên mật khẩu");

  var emailControllor = TextEditingController();
  var passwordControllor = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    forcus = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    forcus.dispose();

    super.dispose();
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

    if(email.isEmpty || password.isEmpty){
       ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bạn chưa nhập đầy đủ thông tin')));
      return;
    }

    List<User> users = await DatabaseApi.getAllUsers();

    User? user = users.firstWhereOrNull((it) => it.email == email && it.password == password);

    if(user != null){
      userid = user.id;
      Navigator.pushReplacementNamed(context, '/main_manager');
    }
    else{
       ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tài khoản không tồn tại ')));
      return;
    }
  }
}
