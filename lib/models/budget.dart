import 'package:floor/floor.dart';

@Entity(tableName: 'budgets')
class Budget {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int userId;

  final int categoryId;

  final double amount;

  final int month;

  final int year;

  final int createdAt;

  Budget({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.month,
    required this.year,
    required this.createdAt,
  });
}