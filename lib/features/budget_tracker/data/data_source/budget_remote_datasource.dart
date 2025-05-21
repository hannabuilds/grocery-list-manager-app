import '../../domain/entities/budget.dart';

abstract class BudgetRemoteDatasource {
  Future<void> setBudget(Budget budget);
  Future<Budget> getBudgetByListId(String listId);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String id);
  Future<List<Budget>> getAllBudgets();
}