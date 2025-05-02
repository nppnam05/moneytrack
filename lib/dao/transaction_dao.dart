import 'package:floor/floor.dart';
import '../models/transaction.dart';

@dao
abstract class TransactionDao {
  @Query('SELECT * FROM transactions')
  Future<List<TransactionModel>> getAllTransactions();

  @Query('SELECT * FROM transactions WHERE id = :id')
  Future<TransactionModel?> getTransactionById(int id);

  @Query('SELECT * FROM transactions WHERE userId = :userId')
  Future<List<TransactionModel>> getTransactionsByUserId(int userId);

  @insert
  Future<void> insertTransaction(TransactionModel transaction);

  @update
  Future<void> updateTransaction(TransactionModel transaction);

  @delete
  Future<void> deleteTransaction(TransactionModel transaction);
}