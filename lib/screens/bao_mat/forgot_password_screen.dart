import 'package:flutter/material.dart';
import 'verifycode_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key, required this.title});

  final String title;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var layMaXacThuc = VerifyCodeScreen(title: "Mã Xác Thực");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quên mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // để nút full chiều ngang
          children: [
            TextField(decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // code logic gửi mã ở đây

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mã xác nhận đã được gửi!')),
                );

                // pop màn hiện tại và qua màn nhận mã xác thực
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => layMaXacThuc),
                );
              },
              child: Text('Gửi mã xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
