import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/user.dart';
import '../../models/wallet.dart';
import '../../models/transaction.dart';
import '../../models/reminder.dart';
import '../../models/categories.dart';
import '../../models/budget.dart';

import '../dao/user_dao.dart';
import '../dao/wallet_dao.dart';
import '../dao/transaction_dao.dart';
import '../dao/reminder_dao.dart';
import '../dao/category_dao.dart';
import '../dao/budget_dao.dart';

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [
    User,
    Wallet,
    TransactionModel,
    Reminder,
    Categories,
    Budget,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  WalletDao get walletDao;
  TransactionDao get transactionDao;
  ReminderDao get reminderDao;
  CategoryDao get categoryDao;
  BudgetDao get budgetDao;
}
