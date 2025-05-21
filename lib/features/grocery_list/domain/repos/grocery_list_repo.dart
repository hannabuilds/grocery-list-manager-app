import 'package:dartz/dartz.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/entities/grocery_list.dart';

import '../../../../core/errors/failure.dart';

abstract class GroceryListRepository {
  Future<Either<Failure, void>> addGroceryList(GroceryList groceryList);
  Future<Either<Failure, List<GroceryList>>> getAllGroceryLists();
  Future<Either<Failure, GroceryList>> getGroceryListById(String id);
  Future<Either<Failure, void>> updateGroceryList(GroceryList groceryList);
  Future<Either<Failure, void>> deleteGroceryList(String id);
}

