import 'package:floor/floor.dart';
import 'package:moneytrack/models/user.dart';

@Entity(
  tableName: 'wallets',
  foreignKeys: [
    ForeignKey(
      childColumns: ['userId'],
      parentColumns: ['id'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
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