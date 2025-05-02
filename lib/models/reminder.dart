import 'package:floor/floor.dart';

@Entity(tableName: 'reminders')
class Reminder {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int userId;

  final String title;

  final String message;

  final int remindAt;

  final int createdAt;

  Reminder({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.remindAt,
    required this.createdAt,
  });
}