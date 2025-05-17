import 'package:floor/floor.dart';
import '../../models/budget.dart';

@dao
abstract class BudgetDao {
  @Query('SELECT * FROM budgets')
  Future<List<Budget>> getAllBudgets();

  @Query('SELECT * FROM budgets WHERE id = :id')
  Future<Budget?> getBudgetById(int id);

  @Query('SELECT * FROM budgets WHERE userId = :userId')
  Future<List<Budget>> getBudgetsByUserId(int userId);

  @insert
  Future<void> insertBudget(Budget budget);

  @update
  Future<void> updateBudget(Budget budget);

  @delete
  Future<void> deleteBudget(Budget budget);
}