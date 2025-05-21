import '../../domain/entities/grocery_list.dart';

abstract class GroceryListRemoteDatasource {
  Future<void> addGroceryList(GroceryList groceryList);
  Future<List<GroceryList>> getAllGroceryLists();
  Future<GroceryList> getGroceryListById(String id);
  Future<void> updateGroceryList(GroceryList groceryList);
  Future<void> deleteGroceryList(String id);
}