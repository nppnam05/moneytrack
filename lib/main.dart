import 'package:flutter/material.dart';
import 'package:moneytrack/screens/main_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/screens.dart';
import 'utils/database/database_api.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();// thiết cho initDatabase async, await một Future trước khi chạy ứng dụng
  await DatabaseApi.initDatabase();// tạo kết nối với Database ngay từ lúc ban đầu

// khởi tạo FlutterLocalNotificationsPlugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Khởi tạo cấu hình notification cho Android
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // Khởi tạo plugin notification với cấu hình trên
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // kiểm tra xem đã có quyền chưa
  // nếu chưa có quyền thì sẽ xin quyền
  await flutterLocalNotificationsPlugin
.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();

  runApp(const MyApp());
}

class AppRoutes{
  static const String login = "login";
  static const String main_manager = "main_manager";
  static const String register = "register";
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
      initialRoute: '/${AppRoutes.main_manager}', 
      onGenerateRoute: (settings) {
        // Áp dụng CustomRoute cho tất cả các route
        Widget? screen;
        // dựa vào dữ liệu truyền đến để lấy màn
        switch (settings.name) {
          case '/${AppRoutes.login}':
            screen = LoginScreen(title: 'Đăng nhập',);
            break;
          case '/${AppRoutes.main_manager}':
            screen = MainManagerScreen();
            break;
          case '/${AppRoutes.register}':
            screen = RegisterScreen(title: 'Đăng ký',);
            break;
        }
        
        return MaterialPageRoute(builder: (_) => screen!);
      },
    );
  }
}

