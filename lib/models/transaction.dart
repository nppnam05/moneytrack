import 'package:floor/floor.dart';

@Entity(tableName: 'transactions')
class TransactionModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int userId;

  final int categoryId;

  final String type;

  final double amount;

  final String description;

  final int transactionDate;

  final int createdAt;

  TransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.description,
    required this.transactionDate,
    required this.createdAt,
  });
}