import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/budget.dart';
import '../repos/budget_repo.dart';

class GetBudgetByListId {
  final BudgetRepository budgetRepository;

  GetBudgetByListId({required this.budgetRepository});

  Future<Either<Failure, Budget>> call(String listId) async =>
    await budgetRepository.getBudgetByListId(listId);
  }

