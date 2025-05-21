import 'package:dartz/dartz.dart';
import 'package:grocery_list_manager/core/errors/exceptions.dart';

import 'package:grocery_list_manager/core/errors/failure.dart';
import 'package:grocery_list_manager/features/grocery_item/data/data_source/grocery_item_remote_datasource.dart';

import 'package:grocery_list_manager/features/grocery_item/domain/entities/grocery_item.dart';

import '../../domain/repos/grocery_item_repo.dart';

class GroceryItemRepositoryImplementation implements GroceryItemRepository {
   final GroceryItemRemoteDatasource _remoteDatasource;
    const GroceryItemRepositoryImplementation (this._remoteDatasource);

  @override
  Future<Either<Failure, void>> addItem(GroceryItem groceryItem) async {
    try {
      return Right(await _remoteDatasource.addItem(groceryItem));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
   try {
      return Right(await _remoteDatasource.deleteItem(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroceryItem>>> getItemsByListId(String listId) async {
    try {
      return Right(await _remoteDatasource.getItemsByListId(listId));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateItem(GroceryItem groceryItem) async {
    try {
      return Right(await _remoteDatasource.updateItem(groceryItem));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<GroceryItem>>> getAllItems() async {
    try {
      return Right(await _remoteDatasource.getAllItems());
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

}