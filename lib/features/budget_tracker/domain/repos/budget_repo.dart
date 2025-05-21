import 'package:dartz/dartz.dart';
import 'package:grocery_list_manager/core/errors/failure.dart';

import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<Either<Failure, void>> setBudget(Budget budget);
  Future<Either<Failure, Budget>> getBudgetByListId(String listId);
  Future<Either<Failure, void>> updateBudget(Budget budget);
  Future<Either<Failure, void>> deleteBudget(String id);
  Future<Either<Failure, List<Budget>>> getAllBudgets();
}
