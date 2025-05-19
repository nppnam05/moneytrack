import 'package:floor/floor.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/user.dart';

@Entity(
  tableName: 'budgets',
  foreignKeys: [
    ForeignKey(
      childColumns: ['userId'],
      parentColumns: ['id'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['categoryId'],
      parentColumns: ['id'],
      entity: Categories,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Budget {
  @PrimaryKey(autoGenerate: true)
  int? id;

  int userId;
  int categoryId;
  double amount;
  bool isDeducted;
  int month;
  int year;
  int createdAt;

  Budget({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.isDeducted,
    required this.month,
    required this.year,
    required this.createdAt,
  });
}