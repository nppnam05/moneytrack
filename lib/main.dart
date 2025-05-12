import 'package:flutter/material.dart';
import 'package:moneytrack/screens/main_screen.dart';
import 'screens/screens.dart';
import 'services/database_api.dart';


void main() async  {
  WidgetsFlutterBinding.ensureInitialized();// thiết cho init async, await một Future trước khi chạy ứng dụng
  await DatabaseApi.init();// tạo kết nối với Database ngay từ lúc ban đầu
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
      initialRoute: '/main_manager',
      onGenerateRoute: (settings) {
        // Áp dụng CustomRoute cho tất cả các route
        Widget? page;
        // dựa vào dữ liệu truyền đến để lấy màn
        switch (settings.name) {
          case '/login':
            page = LoginScreen(title: 'Đăng nhập',);
            break;
          case '/main_manager':
            page = MainManagerScreen();
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