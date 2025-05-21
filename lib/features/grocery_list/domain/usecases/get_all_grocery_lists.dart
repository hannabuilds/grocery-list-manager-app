import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/grocery_list.dart';
import '../repos/grocery_list_repo.dart';

class GetAllGroceryLists {
  final GroceryListRepository groceryListRepository;

  GetAllGroceryLists({required this.groceryListRepository});

  Future<Either<Failure, List<GroceryList>>> call() async =>
    await groceryListRepository.getAllGroceryLists();
  }


