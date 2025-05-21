import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/budget.dart';
import '../repos/budget_repo.dart';

class UpdateBudget {
  final BudgetRepository budgetRepository;

  UpdateBudget({required this.budgetRepository});

  Future<Either<Failure, void>> call(Budget budget) async =>
    await budgetRepository.updateBudget(budget);
  }

