import '../models/user.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../models/reminder.dart';
import '../models/budget.dart';
import '../models/categories.dart';

import 'app_database.dart';

import '../dao/user_dao.dart';
import '../dao/wallet_dao.dart';
import '../dao/transaction_dao.dart';
import '../dao/reminder_dao.dart';
import '../dao/category_dao.dart';
import '../dao/budget_dao.dart';


import 'package:flutter/foundation.dart';

// Định nghĩa callback
typedef OnSuccess = void Function();
typedef OnError = void Function(dynamic error);

class DatabaseApi {
  static late AppDatabase _db;

  static late UserDao _userDao;
  static late WalletDao _walletDao;
  static late TransactionDao _transactionDao;
  static late ReminderDao _reminderDao;
  static late CategoryDao _categoryDao;
  static late BudgetDao _budgetDao;

  /// Gọi 1 lần duy nhất trong main()
  static Future<void> init() async {
    _db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _userDao = _db.userDao;
    _walletDao = _db.walletDao;
    _transactionDao = _db.transactionDao;
    _reminderDao = _db.reminderDao;
    _categoryDao = _db.categoryDao;
    _budgetDao = _db.budgetDao;
  }

  // ----------------- User -----------------

  static Future<void> insertUser(
    User user, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _userDao.insertUser(user);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> updateUser(
    User user, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _userDao.updateUser(user);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> deleteUser(
    User user, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _userDao.deleteUser(user);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<List<User>> getAllUsers() async {
    return await _userDao.getAllUsers();
  }

  static Future<User?> getUserById(int id) async {
    return await _userDao.getUserById(id);
  }

  // ----------------- Wallet -----------------

  static Future<void> insertWallet(
    Wallet wallet, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _walletDao.insertWallet(wallet);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> updateWallet(
    Wallet wallet, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _walletDao.updateWallet(wallet);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> deleteWallet(
    Wallet wallet, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _walletDao.deleteWallet(wallet);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<List<Wallet>> getAllWallets() async {
    return await _walletDao.getAllWallets();
  }

  static Future<Wallet?> getWalletById(int id) async {
    return await _walletDao.getWalletById(id);
  }

  static Future<List<Wallet>> getWalletsByUserId(int userId) async {
    return await _walletDao.getWalletsByUserId(userId);
  }

  // ----------------- Transaction -----------------

  static Future<void> insertTransaction(
    TransactionModel transaction, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _transactionDao.insertTransaction(transaction);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> updateTransaction(
    TransactionModel transaction, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _transactionDao.updateTransaction(transaction);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> deleteTransaction(
    TransactionModel transaction, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _transactionDao.deleteTransaction(transaction);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<List<TransactionModel>> getAllTransactions() async {
    return await _transactionDao.getAllTransactions();
  }

  static Future<TransactionModel?> getTransactionById(int id) async {
    return await _transactionDao.getTransactionById(id);
  }

  static Future<List<TransactionModel>> getTransactionsByUserId(int userId) async {
    return await _transactionDao.getTransactionsByUserId(userId);
  }

  // ----------------- Reminder -----------------

  static Future<void> insertReminder(
    Reminder reminder, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _reminderDao.insertReminder(reminder);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> updateReminder(
    Reminder reminder, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _reminderDao.updateReminder(reminder);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> deleteReminder(
    Reminder reminder, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _reminderDao.deleteReminder(reminder);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<List<Reminder>> getAllReminders() async {
    return await _reminderDao.getAllReminders();
  }

  static Future<Reminder?> getReminderById(int id) async {
    return await _reminderDao.getReminderById(id);
  }

  static Future<List<Reminder>> getRemindersByUserId(int userId) async {
    return await _reminderDao.getRemindersByUserId(userId);
  }

  // ----------------- Category -----------------

  static Future<void> insertCategory(
    Categories category, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _categoryDao.insertCategory(category);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> updateCategory(
    Categories category, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _categoryDao.updateCategory(category);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> deleteCategory(
    Categories category, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _categoryDao.deleteCategory(category);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<List<Categories>> getAllCategories() async {
    return await _categoryDao.getAllCategories();
  }

  static Future<Categories?> getCategoryById(int id) async {
    return await _categoryDao.getCategoryById(id);
  }

  // ----------------- Budget -----------------

  static Future<void> insertBudget(
    Budget budget, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _budgetDao.insertBudget(budget);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> updateBudget(
    Budget budget, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _budgetDao.updateBudget(budget);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<void> deleteBudget(
    Budget budget, {
    required OnSuccess onSuccess,
    required OnError onError,
  }) async {
    try {
      await _budgetDao.deleteBudget(budget);
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }

  static Future<List<Budget>> getAllBudgets() async {
    return await _budgetDao.getAllBudgets();
  }

  static Future<Budget?> getBudgetById(int id) async {
    return await _budgetDao.getBudgetById(id);
  }

  static Future<List<Budget>> getBudgetsByUserId(int userId) async {
    return await _budgetDao.getBudgetsByUserId(userId);
  }
}