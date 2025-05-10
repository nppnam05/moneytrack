import '../models/user.dart';
import 'app_database.dart';
import '../dao/user_dao.dart';

import 'package:flutter/foundation.dart';

// định nghĩa callback
typedef OnSuccess = void Function();
typedef OnError = void Function(dynamic error);

class DatabaseApi {
  static late AppDatabase _db;
  static late UserDao _userDao;

  /// Gọi 1 lần duy nhất trong main()
  static Future<void> init() async {
    _db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _userDao = _db.userDao;
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
}
