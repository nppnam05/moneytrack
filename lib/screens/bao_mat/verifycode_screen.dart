import 'package:flutter/material.dart';
import 'package:moneytrack/screens/bao_mat/login_screen.dart';
import '../../utils/email_otp.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.title, required this.userID});

  final String title;
  final int userID;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  var email_otp = EmailService();

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

  void _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng nhập mã xác nhận')));
      return;
    }

    bool isValid = await email_otp.verifyOTP(code);
    if (isValid) {
      // Nếu mã đúng thì xóa hết các màn trước đó và khởi tạo màn mới
      LoginScreen.userid = widget.userID;
      Navigator.of(context).pushNamedAndRemoveUntil('/main_manager', (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mã xác nhận không đúng')));
    }
    _codeController.clear();
  }
}
