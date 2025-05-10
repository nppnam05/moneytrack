import 'app_database.dart';

class DatabaseProvider {
  static AppDatabase? _database;

  static Future<AppDatabase> get database async {
    // Nếu database đã được khởi tạo, trả lại luôn
    if (_database != null) return _database!;

    // Nếu chưa, thì khởi tạo
    _database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build();

    return _database!;
  }
}
