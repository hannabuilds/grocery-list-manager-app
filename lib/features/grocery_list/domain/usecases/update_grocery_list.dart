import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/grocery_list.dart';
import '../repos/grocery_list_repo.dart';

class UpdateGroceryList {
  final GroceryListRepository groceryListRepository;

  UpdateGroceryList({required this.groceryListRepository});

  Future<Either<Failure, void>> call(GroceryList groceryList) async =>
    await groceryListRepository.updateGroceryList(groceryList);
  }


