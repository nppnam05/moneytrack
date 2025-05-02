import 'package:flutter/material.dart';
import 'verifycode_screen.dart';
import '../../utils/email_otp.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key, required this.title});

  final String title;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var layMaXacThuc = VerifyCodeScreen(title: "Mã Xác Thực");
  var emailControllor = TextEditingController();
  var email_otp = EmailService();
  

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
            TextField(
              controller: emailControllor,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(!emailControllor.text.isEmpty){
                  // code logic gửi mã ở đây
                email_otp.guiMaOTP(emailControllor.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mã xác nhận đã được gửi!')),
                );

                // pop màn hiện tại và qua màn nhận mã xác thực
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => layMaXacThuc),
                );
                }
              },
              child: Text('Gửi mã xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
