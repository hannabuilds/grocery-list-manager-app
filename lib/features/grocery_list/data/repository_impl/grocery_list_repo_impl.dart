import 'package:dartz/dartz.dart';
import 'package:grocery_list_manager/core/errors/exceptions.dart';

import 'package:grocery_list_manager/core/errors/failure.dart';
import 'package:grocery_list_manager/features/grocery_list/data/data_source/grocery_list_remote_datasource.dart';

import 'package:grocery_list_manager/features/grocery_list/domain/entities/grocery_list.dart';

import '../../domain/repos/grocery_list_repo.dart';

class GroceryListRepositoryImplementation implements GroceryListRepository {
   final GroceryListRemoteDatasource _remoteDatasource;

  const GroceryListRepositoryImplementation (this._remoteDatasource);

  @override
  Future<Either<Failure, void>> addGroceryList(GroceryList groceryList) async {
    try {
      return Right(await _remoteDatasource.addGroceryList(groceryList));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroceryList(String id) async {
    try {
      return Right(await _remoteDatasource.deleteGroceryList(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroceryList>>> getAllGroceryLists() async {
    try {
      return Right(await _remoteDatasource.getAllGroceryLists());
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGroceryList(GroceryList groceryList) async {
   try {
      return Right(await _remoteDatasource.updateGroceryList(groceryList));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, GroceryList>> getGroceryListById(String id) async {
  try {
    final groceryList = await _remoteDatasource.getGroceryListById(id);
    return Right(groceryList);
  } on APIException catch (e) {
    return Left(APIFailure(message: e.message, statusCode: e.statusCode));
  } on Exception catch (e) {
    return Left(GeneralFailure(message: e.toString()));
  }
}

}