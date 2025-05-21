import 'package:dartz/dartz.dart';
import 'package:grocery_list_manager/core/errors/exceptions.dart';

import 'package:grocery_list_manager/core/errors/failure.dart';
import 'package:grocery_list_manager/features/budget_tracker/data/data_source/budget_remote_datasource.dart';

import 'package:grocery_list_manager/features/budget_tracker/domain/entities/budget.dart';

import '../../domain/repos/budget_repo.dart';

class BudgetRepositoryImplementation implements BudgetRepository {
  final BudgetRemoteDatasource _remoteDatasource;

  const BudgetRepositoryImplementation(this._remoteDatasource);

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      return Right(await _remoteDatasource.deleteBudget(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetByListId(String listId) async {
    try {
      return Right(await _remoteDatasource.getBudgetByListId(listId));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }

  }

  @override
  Future<Either<Failure, void>> setBudget(Budget budget) async {
    try {
      return Right(await _remoteDatasource.setBudget(budget));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }

  }

  @override
  Future<Either<Failure, void>> updateBudget(Budget budget) async {
     try {
      return Right(await _remoteDatasource.updateBudget(budget));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Budget>>> getAllBudgets() async {
  try {
    final budgets = await _remoteDatasource.getAllBudgets();
    return Right(budgets);
  } on APIException catch (e) {
    return Left(APIFailure(message: e.message, statusCode: e.statusCode));
  } on Exception catch (e) {
    return Left(GeneralFailure(message: e.toString()));
  }
}
}

