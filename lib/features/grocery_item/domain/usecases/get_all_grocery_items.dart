import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/grocery_item.dart';
import '../repos/grocery_item_repo.dart';

class GetAllGroceryItems {
  final GroceryItemRepository groceryItemRepository;

  GetAllGroceryItems({required this.groceryItemRepository});

  Future<Either<Failure, List<GroceryItem>>> call() async =>
    await groceryItemRepository.getAllItems();
}
