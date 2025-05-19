// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  WalletDao? _walletDaoInstance;

  TransactionDao? _transactionDaoInstance;

  ReminderDao? _reminderDaoInstance;

  CategoryDao? _categoryDaoInstance;

  BudgetDao? _budgetDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `totalExpenditure` REAL NOT NULL, `totalRevenue` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `wallets` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `balance` REAL NOT NULL, FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transactions` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `categoryId` INTEGER NOT NULL, `type` TEXT NOT NULL, `amount` REAL NOT NULL, `description` TEXT NOT NULL, `transactionDate` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`categoryId`) REFERENCES `categories` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reminders` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `title` TEXT NOT NULL, `message` TEXT NOT NULL, `remindAt` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `cost` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `budgets` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `categoryId` INTEGER NOT NULL, `amount` REAL NOT NULL, `isDeducted` INTEGER NOT NULL, `month` INTEGER NOT NULL, `year` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`categoryId`) REFERENCES `categories` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  WalletDao get walletDao {
    return _walletDaoInstance ??= _$WalletDao(database, changeListener);
  }

  @override
  TransactionDao get transactionDao {
    return _transactionDaoInstance ??=
        _$TransactionDao(database, changeListener);
  }

  @override
  ReminderDao get reminderDao {
    return _reminderDaoInstance ??= _$ReminderDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  BudgetDao get budgetDao {
    return _budgetDaoInstance ??= _$BudgetDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'totalExpenditure': item.totalExpenditure,
                  'totalRevenue': item.totalRevenue
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'totalExpenditure': item.totalExpenditure,
                  'totalRevenue': item.totalRevenue
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'totalExpenditure': item.totalExpenditure,
                  'totalRevenue': item.totalRevenue
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<User?> findUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            totalExpenditure: row['totalExpenditure'] as double,
            totalRevenue: row['totalRevenue'] as double),
        arguments: [email]);
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            totalExpenditure: row['totalExpenditure'] as double,
            totalRevenue: row['totalRevenue'] as double));
  }

  @override
  Future<User?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            totalExpenditure: row['totalExpenditure'] as double,
            totalRevenue: row['totalRevenue'] as double),
        arguments: [id]);
  }

  @override
  Future<int> insertUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$WalletDao extends WalletDao {
  _$WalletDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _walletInsertionAdapter = InsertionAdapter(
            database,
            'wallets',
            (Wallet item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'balance': item.balance
                }),
        _walletUpdateAdapter = UpdateAdapter(
            database,
            'wallets',
            ['id'],
            (Wallet item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'balance': item.balance
                }),
        _walletDeletionAdapter = DeletionAdapter(
            database,
            'wallets',
            ['id'],
            (Wallet item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'balance': item.balance
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Wallet> _walletInsertionAdapter;

  final UpdateAdapter<Wallet> _walletUpdateAdapter;

  final DeletionAdapter<Wallet> _walletDeletionAdapter;

  @override
  Future<List<Wallet>> getAllWallets() async {
    return _queryAdapter.queryList('SELECT * FROM wallets',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            balance: row['balance'] as double));
  }

  @override
  Future<Wallet?> getWalletById(int id) async {
    return _queryAdapter.query('SELECT * FROM wallets WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            balance: row['balance'] as double),
        arguments: [id]);
  }

  @override
  Future<List<Wallet>> getWalletsByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM wallets WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Wallet(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            balance: row['balance'] as double),
        arguments: [userId]);
  }

  @override
  Future<void> insertWallet(Wallet wallet) async {
    await _walletInsertionAdapter.insert(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWallet(Wallet wallet) async {
    await _walletUpdateAdapter.update(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWallet(Wallet wallet) async {
    await _walletDeletionAdapter.delete(wallet);
  }
}

class _$TransactionDao extends TransactionDao {
  _$TransactionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _transactionModelInsertionAdapter = InsertionAdapter(
            database,
            'transactions',
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'type': item.type,
                  'amount': item.amount,
                  'description': item.description,
                  'transactionDate': item.transactionDate,
                  'createdAt': item.createdAt
                }),
        _transactionModelUpdateAdapter = UpdateAdapter(
            database,
            'transactions',
            ['id'],
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'type': item.type,
                  'amount': item.amount,
                  'description': item.description,
                  'transactionDate': item.transactionDate,
                  'createdAt': item.createdAt
                }),
        _transactionModelDeletionAdapter = DeletionAdapter(
            database,
            'transactions',
            ['id'],
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'type': item.type,
                  'amount': item.amount,
                  'description': item.description,
                  'transactionDate': item.transactionDate,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionModel> _transactionModelInsertionAdapter;

  final UpdateAdapter<TransactionModel> _transactionModelUpdateAdapter;

  final DeletionAdapter<TransactionModel> _transactionModelDeletionAdapter;

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return _queryAdapter.queryList('SELECT * FROM transactions',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            categoryId: row['categoryId'] as int,
            type: row['type'] as String,
            amount: row['amount'] as double,
            description: row['description'] as String,
            transactionDate: row['transactionDate'] as int,
            createdAt: row['createdAt'] as int));
  }

  @override
  Future<TransactionModel?> getTransactionById(int id) async {
    return _queryAdapter.query('SELECT * FROM transactions WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            categoryId: row['categoryId'] as int,
            type: row['type'] as String,
            amount: row['amount'] as double,
            description: row['description'] as String,
            transactionDate: row['transactionDate'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [id]);
  }

  @override
  Future<List<TransactionModel>> getTransactionsByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM transactions WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            categoryId: row['categoryId'] as int,
            type: row['type'] as String,
            amount: row['amount'] as double,
            description: row['description'] as String,
            transactionDate: row['transactionDate'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [userId]);
  }

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    await _transactionModelInsertionAdapter.insert(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionModelUpdateAdapter.update(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _transactionModelDeletionAdapter.delete(transaction);
  }
}

class _$ReminderDao extends ReminderDao {
  _$ReminderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reminderInsertionAdapter = InsertionAdapter(
            database,
            'reminders',
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'title': item.title,
                  'message': item.message,
                  'remindAt': item.remindAt,
                  'createdAt': item.createdAt
                }),
        _reminderUpdateAdapter = UpdateAdapter(
            database,
            'reminders',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'title': item.title,
                  'message': item.message,
                  'remindAt': item.remindAt,
                  'createdAt': item.createdAt
                }),
        _reminderDeletionAdapter = DeletionAdapter(
            database,
            'reminders',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'title': item.title,
                  'message': item.message,
                  'remindAt': item.remindAt,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reminder> _reminderInsertionAdapter;

  final UpdateAdapter<Reminder> _reminderUpdateAdapter;

  final DeletionAdapter<Reminder> _reminderDeletionAdapter;

  @override
  Future<List<Reminder>> getAllReminders() async {
    return _queryAdapter.queryList('SELECT * FROM reminders',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            title: row['title'] as String,
            message: row['message'] as String,
            remindAt: row['remindAt'] as int,
            createdAt: row['createdAt'] as int));
  }

  @override
  Future<Reminder?> getReminderById(int id) async {
    return _queryAdapter.query('SELECT * FROM reminders WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            title: row['title'] as String,
            message: row['message'] as String,
            remindAt: row['remindAt'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Reminder>> getRemindersByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM reminders WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            title: row['title'] as String,
            message: row['message'] as String,
            remindAt: row['remindAt'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [userId]);
  }

  @override
  Future<void> insertReminder(Reminder reminder) async {
    await _reminderInsertionAdapter.insert(reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    await _reminderUpdateAdapter.update(reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReminder(Reminder reminder) async {
    await _reminderDeletionAdapter.delete(reminder);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoriesInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (Categories item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'cost': item.cost
                }),
        _categoriesUpdateAdapter = UpdateAdapter(
            database,
            'categories',
            ['id'],
            (Categories item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'cost': item.cost
                }),
        _categoriesDeletionAdapter = DeletionAdapter(
            database,
            'categories',
            ['id'],
            (Categories item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'cost': item.cost
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Categories> _categoriesInsertionAdapter;

  final UpdateAdapter<Categories> _categoriesUpdateAdapter;

  final DeletionAdapter<Categories> _categoriesDeletionAdapter;

  @override
  Future<List<Categories>> getAllCategories() async {
    return _queryAdapter.queryList('SELECT * FROM categories',
        mapper: (Map<String, Object?> row) => Categories(
            id: row['id'] as int?,
            name: row['name'] as String,
            cost: row['cost'] as double));
  }

  @override
  Future<Categories?> getCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Categories(
            id: row['id'] as int?,
            name: row['name'] as String,
            cost: row['cost'] as double),
        arguments: [id]);
  }

  @override
  Future<void> insertCategory(Categories category) async {
    await _categoriesInsertionAdapter.insert(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCategory(Categories category) async {
    await _categoriesUpdateAdapter.update(category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(Categories category) async {
    await _categoriesDeletionAdapter.delete(category);
  }
}

class _$BudgetDao extends BudgetDao {
  _$BudgetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _budgetInsertionAdapter = InsertionAdapter(
            database,
            'budgets',
            (Budget item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'amount': item.amount,
                  'isDeducted': item.isDeducted ? 1 : 0,
                  'month': item.month,
                  'year': item.year,
                  'createdAt': item.createdAt
                }),
        _budgetUpdateAdapter = UpdateAdapter(
            database,
            'budgets',
            ['id'],
            (Budget item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'amount': item.amount,
                  'isDeducted': item.isDeducted ? 1 : 0,
                  'month': item.month,
                  'year': item.year,
                  'createdAt': item.createdAt
                }),
        _budgetDeletionAdapter = DeletionAdapter(
            database,
            'budgets',
            ['id'],
            (Budget item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'categoryId': item.categoryId,
                  'amount': item.amount,
                  'isDeducted': item.isDeducted ? 1 : 0,
                  'month': item.month,
                  'year': item.year,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Budget> _budgetInsertionAdapter;

  final UpdateAdapter<Budget> _budgetUpdateAdapter;

  final DeletionAdapter<Budget> _budgetDeletionAdapter;

  @override
  Future<List<Budget>> getAllBudgets() async {
    return _queryAdapter.queryList('SELECT * FROM budgets',
        mapper: (Map<String, Object?> row) => Budget(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            categoryId: row['categoryId'] as int,
            amount: row['amount'] as double,
            isDeducted: (row['isDeducted'] as int) != 0,
            month: row['month'] as int,
            year: row['year'] as int,
            createdAt: row['createdAt'] as int));
  }

  @override
  Future<Budget?> getBudgetById(int id) async {
    return _queryAdapter.query('SELECT * FROM budgets WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Budget(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            categoryId: row['categoryId'] as int,
            amount: row['amount'] as double,
            isDeducted: (row['isDeducted'] as int) != 0,
            month: row['month'] as int,
            year: row['year'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Budget>> getBudgetsByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM budgets WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Budget(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            categoryId: row['categoryId'] as int,
            amount: row['amount'] as double,
            isDeducted: (row['isDeducted'] as int) != 0,
            month: row['month'] as int,
            year: row['year'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [userId]);
  }

  @override
  Future<void> insertBudget(Budget budget) async {
    await _budgetInsertionAdapter.insert(budget, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    await _budgetUpdateAdapter.update(budget, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBudget(Budget budget) async {
    await _budgetDeletionAdapter.delete(budget);
  }
}
