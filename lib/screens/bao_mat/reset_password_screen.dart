import 'package:flutter/material.dart';
import 'package:moneytrack/services/database_api.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.userID});
  final int userID;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp')));
      return;
    }

    // Xử lý đổi mật khẩu ở đây
    var user = await DatabaseApi.getUserById(widget.userID);
    user?.password = newPassword;
    DatabaseApi.updateUser(
      user!,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt lại mật khẩu thành công')),
        );
        // quay lại màn đăng nhập
        Navigator.pop(context);
      },
      onError: (error) {
        print("$error");
      },
    );
  }
}
