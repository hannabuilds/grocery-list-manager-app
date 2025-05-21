import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repos/grocery_item_repo.dart';

class DeleteGroceryItem {
  final GroceryItemRepository groceryItemRepository;

  DeleteGroceryItem({required this.groceryItemRepository});

  Future<Either<Failure, void>> call(String id) async =>
    await groceryItemRepository.deleteItem(id);
  }


