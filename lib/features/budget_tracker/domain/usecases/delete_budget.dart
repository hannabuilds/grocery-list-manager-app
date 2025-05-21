import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repos/budget_repo.dart';

class DeleteBudget {
  final BudgetRepository budgetRepository;

  DeleteBudget({required this.budgetRepository});

  Future<Either<Failure, void>> call(String id) async =>
    await budgetRepository.deleteBudget(id);
  }

