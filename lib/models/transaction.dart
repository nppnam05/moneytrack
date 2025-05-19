import 'package:floor/floor.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/models/user.dart';

@Entity(
  tableName: 'transactions',
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
class TransactionModel {
  @PrimaryKey(autoGenerate: true)
  int? id;

  int userId;
  int categoryId;
  String type;
  double amount;
  String description;
  int transactionDate;
  int createdAt;

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