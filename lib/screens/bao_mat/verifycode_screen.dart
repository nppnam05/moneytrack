import 'package:flutter/material.dart';
import 'reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.title});

  final String title;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  var layLaiMatKhau = ResetPasswordScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nhập mã xác thực đã gửi đến email của bạn:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Mã xác thực',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _verifyCode, child: Text('Xác nhận')),
          ],
        ),
      ),
    );
  }

  
  void _verifyCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng nhập mã xác nhận')));
    } else {
      // TODO: Xử lý xác thực mã tại đây
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mã $code đã được xác nhận')));



      // nếu mã đúng thì nó sẽ qua màn lấy lại mật khẩu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => layLaiMatKhau),
      );
    }
  }
}
