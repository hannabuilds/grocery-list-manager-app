import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/grocery_item.dart';

abstract class GroceryItemRepository {
  Future<Either<Failure, void>> addItem(GroceryItem groceryItem);
  Future<Either<Failure, List<GroceryItem>>> getItemsByListId(String listId);
  Future<Either<Failure, void>> updateItem(GroceryItem groceryItem);
  Future<Either<Failure, void>> deleteItem(String id);
  Future<Either<Failure, List<GroceryItem>>> getAllItems();
}

