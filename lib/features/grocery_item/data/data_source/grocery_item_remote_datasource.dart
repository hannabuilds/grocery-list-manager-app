import '../../domain/entities/grocery_item.dart';

abstract class GroceryItemRemoteDatasource {
  Future<void> addItem(GroceryItem groceryItem);
  Future<List<GroceryItem>> getItemsByListId(String listId);
  Future<void> updateItem(GroceryItem groceryItem);
  Future<void> deleteItem(String id);
  Future<List<GroceryItem>> getAllItems();
}
