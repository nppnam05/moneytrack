import 'package:flutter/material.dart';
import 'package:moneytrack/screens/screens.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.title});

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var dangKy = RegisterScreen(title: "Đăng ký");
  var quenMatKhau = ForgotPasswordScreen(title: "Quên mật khẩu");

  var emailControllor = TextEditingController();
  var passControllor = TextEditingController();

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
              decoration: InputDecoration(
                labelText: 'Email',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passControllor,
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

        Navigator.pushReplacementNamed(context, '/main_manager');
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
}
