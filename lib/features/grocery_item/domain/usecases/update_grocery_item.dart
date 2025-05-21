import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/grocery_item.dart';
import '../repos/grocery_item_repo.dart';

class UpdateGroceryItem {
  final GroceryItemRepository groceryItemRepository;

  UpdateGroceryItem({required this.groceryItemRepository});

  Future<Either<Failure, void>> call(GroceryItem groceryItem) async =>
    await groceryItemRepository.updateItem(groceryItem);
  }


