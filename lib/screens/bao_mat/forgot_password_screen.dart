import 'package:flutter/material.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/services/database_api.dart';
import 'verifycode_screen.dart';
import '../../utils/email_otp.dart';
import 'package:collection/collection.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key, required this.title});

  final String title;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int userid = -1;
 
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
              onPressed: () async {
                
                if (await _kiemTraEmail()) {
                  // code logic gửi mã ở đây
                  email_otp.guiMaOTP(emailControllor.text.trim());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mã xác nhận đã được gửi!')),
                  );

                  // pop màn hiện tại và qua màn nhận mã xác thực
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyCodeScreen(title: "Mã Xác Thực", userID: userid)),
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

  Future<bool> _kiemTraEmail() async {
    if (emailControllor.text.isNotEmpty) {
      String email = emailControllor.text.trim();
      var users = await DatabaseApi.getAllUsers();

      User? checkUser = users.firstWhereOrNull((it) => it.email == email);
      if (checkUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('email không tồn tại')));
        return false;
      }
      userid = checkUser.id!;
      return true;
    }


    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Bạn chưa nhập đầy đủ thông tin')));
    return false;
  }
}
