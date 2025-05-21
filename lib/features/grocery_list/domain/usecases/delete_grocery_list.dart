import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repos/grocery_list_repo.dart';

class DeleteGroceryList {
  final GroceryListRepository groceryListRepository;

  DeleteGroceryList({required this.groceryListRepository});

  Future<Either<Failure, void>> call(String id) async =>
    await groceryListRepository.deleteGroceryList(id);
  }


