import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/grocery_list.dart';
import '../repos/grocery_list_repo.dart';

class AddGroceryList {
  final GroceryListRepository groceryListRepository;

  AddGroceryList({required this.groceryListRepository});

 Future<Either<Failure, void>> call(GroceryList groceryList) async =>
    await groceryListRepository.addGroceryList(groceryList);
  }


