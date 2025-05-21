import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/grocery_item.dart';
import '../repos/grocery_item_repo.dart';

class GetItemsByListId {
  final GroceryItemRepository groceryItemRepository;

  GetItemsByListId({required this.groceryItemRepository});

  Future<Either<Failure, List<GroceryItem>>> call(String listId) async =>
    await groceryItemRepository.getItemsByListId(listId);
  }


