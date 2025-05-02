import 'package:floor/floor.dart';

@Entity(tableName: 'wallets')
class Wallet {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int userId;

  final double balance;

  Wallet({
    this.id,
    required this.userId,
    required this.balance,
  });
}