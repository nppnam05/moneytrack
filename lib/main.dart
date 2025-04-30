import 'package:flutter/material.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý chi tiêu',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/add_budget',
      onGenerateRoute: (settings) {
        // Áp dụng CustomRoute cho tất cả các route
        Widget? page;
        // dựa vào dữ liệu truyền đến để lấy màn
        switch (settings.name) {
          case '/login':
            page = LoginScreen(title: 'Đăng nhập',);
            break;
          case '/forgot_password':
            page = ForgotPasswordScreen(title: 'Quên mật khẩu',);
            break;
            case '/add_budget':
            page = AddBudgetScreen(title: 'thêm ngân sách',);
            break;
          case '/home':
            page = HomeScreen(title: 'Trang chủ',);
            break;
          case '/transactions':
            page = TransactionsScreen(title: 'sổ giao dịch',);
            break;
          case '/budget':
            page = BudgetScreen(title: 'ngân sách',);
            break;
          case '/profile':
            page = ProfileScreens(title: '...',);
            break;
        }

        // nếu màn này có thì sẽ hiện ra
        if (page != null) {
          return MaterialPageRoute(builder: (_) => page!);
        }
        return null;
      },
    );
  }
}