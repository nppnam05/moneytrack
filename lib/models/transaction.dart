import 'package:floor/floor.dart';

@Entity(tableName: 'transactions')
class TransactionModel {
  @PrimaryKey(autoGenerate: true)
   int id;

   int userId;

   int categoryId;

   String type;

   double amount;

   String description;

   int transactionDate;

   int createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.description,
    required this.transactionDate,
    required this.createdAt,
  });

  @override
  String toString() {
    return "$id - $userId - $categoryId - $type - $amount - $description - $transactionDate - $createdAt";
  }
}