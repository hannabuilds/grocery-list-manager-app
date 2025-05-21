import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/budget.dart';
import '../repos/budget_repo.dart';

class GetAllBudgets {
  final BudgetRepository budgetRepository;

  GetAllBudgets({required this.budgetRepository});

  Future<Either<Failure, List<Budget>>> call() async =>
    await budgetRepository.getAllBudgets();
  
}
