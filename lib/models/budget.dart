import 'package:floor/floor.dart';

@Entity(tableName: 'budgets')
class Budget {
  @PrimaryKey(autoGenerate: true)
   int? id;

   int userId;

   int categoryId;

   double amount;

   int month;

   int year;

   int createdAt;

  Budget({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.month,
    required this.year,
    required this.createdAt,
  });

  @override
  String toString() {
    return "$id - $userId - $categoryId - $amount - $month - $year - $createdAt";
  }
}