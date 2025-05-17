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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _showNotification();
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Hello!',
      'This is a test notification.',
      platformChannelSpecifics,
    );
  }
}