import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../main.dart'; // Để dùng flutterLocalNotificationsPlugin đã khởi tạo ở main.dart

class ShowNotification {
  static Map<String, bool> checkMap = {};
  static Future<void> showBudgetNotification(String title, String body, int id) async {
    //  Cấu hình chi tiết cho thông báo Android (channel, mức độ ưu tiên, mô tả...)
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'budget_channel', // ID kênh thông báo (phải duy nhất)
          'Cảnh báo ngân sách', // Tên kênh hiển thị cho người dùng
          channelDescription: 'Thông báo khi ngân sách còn 20%',
          importance: Importance.max,
          priority: Priority.high,
        );
    // Gộp cấu hình cho các nền tảng (ở đây chỉ dùng Android)
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );


    // Hiển thị thông báo với tiêu đề và nội dung truyền vào
    await flutterLocalNotificationsPlugin.show(
      id, // ID thông báo
      title, //Tiêu đề thông báo.
      body, // Nội dung
      platformChannelSpecifics,
    );
  }
}
