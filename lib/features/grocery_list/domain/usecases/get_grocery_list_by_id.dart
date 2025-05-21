import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/grocery_list.dart';
import '../repos/grocery_list_repo.dart';

class GetGroceryListById {
  final GroceryListRepository groceryListRepository;

  GetGroceryListById({required this.groceryListRepository});

  Future<Either<Failure, GroceryList>> call(String id) async {
    return await groceryListRepository.getGroceryListById(id);
  }
}

