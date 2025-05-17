import 'package:floor/floor.dart';
import '../../models/reminder.dart';

@dao
abstract class ReminderDao {
  @Query('SELECT * FROM reminders')
  Future<List<Reminder>> getAllReminders();

  @Query('SELECT * FROM reminders WHERE id = :id')
  Future<Reminder?> getReminderById(int id);

  @Query('SELECT * FROM reminders WHERE userId = :userId')
  Future<List<Reminder>> getRemindersByUserId(int userId);

  @insert
  Future<void> insertReminder(Reminder reminder);

  @update
  Future<void> updateReminder(Reminder reminder);

  @delete
  Future<void> deleteReminder(Reminder reminder);
}