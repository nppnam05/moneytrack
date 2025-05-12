import 'package:floor/floor.dart';

@Entity(tableName: 'reminders')
class Reminder {
  @PrimaryKey(autoGenerate: true)
   int? id;

   int userId;

   String title;

   String message;

   int remindAt;

   int createdAt;

  Reminder({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.remindAt,
    required this.createdAt,
  });

  @override
  String toString() {
    return "$id - $userId - $title - $message - $remindAt - $createdAt";
  }
}