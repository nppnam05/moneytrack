import 'package:floor/floor.dart';

@Entity(tableName: 'wallets')
class Wallet {
  @PrimaryKey(autoGenerate: true)
   int? id;

   int userId;

   double balance;

  Wallet({
    this.id,
    required this.userId,
    required this.balance,
  });

  @override
  String toString() {
    return "$id - $userId - $balance";
  }
}