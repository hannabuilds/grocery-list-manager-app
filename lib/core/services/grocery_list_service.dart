import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/budget_tracker/data/models/budget_model.dart';
import '../../features/grocery_item/data/models/grocery_item_model.dart';
import '../../features/grocery_list/data/models/grocery_list_model.dart';

class GroceryListDetails {
  final GroceryListModel groceryList;
  final List<GroceryItemModel> groceryItems;
  final BudgetModel? budget;

  GroceryListDetails({
    required this.groceryList,
    required this.groceryItems,
    this.budget,
  });
}

class GroceryListService {
  final FirebaseFirestore _firestore;

  GroceryListService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetch combined data for a grocery list by its `listId`.
  Future<GroceryListDetails> fetchGroceryListDetails(String listId) async {
    try {
      // Step 1: Fetch the grocery list details (single document)
      final groceryListRef = _firestore.collection('groceryLists').doc(listId);
      final groceryListSnapshot = await groceryListRef.get();
      if (!groceryListSnapshot.exists) {
        throw Exception('Grocery list not found.');
      }
      final groceryListData =
          GroceryListModel.fromMap(groceryListSnapshot.data()!);

      // Step 2: Fetch grocery items for the list (subcollection under groceryList)
      final groceryItemsRef = _firestore
          .collection('groceryLists')
          .doc(listId)
          .collection('groceryItems'); // Reference subcollection
      final groceryItemsSnapshot = await groceryItemsRef.get();
      final groceryItems = groceryItemsSnapshot.docs
          .map((doc) => GroceryItemModel.fromMap(doc.data()))
          .toList();

      // Step 3: Fetch budget for the list (single document in the budgets collection)
      final budgetRef = _firestore
          .collection('groceryLists')
          .doc(listId)
          .collection('budgets');
      final budgetSnapshot = await budgetRef.get();
      BudgetModel? budget;
      if (budgetSnapshot.docs.isNotEmpty) {
        budget = BudgetModel.fromMap(budgetSnapshot.docs.first.data());
      }

      // Return the combined result
      return GroceryListDetails(
        groceryList: groceryListData,
        groceryItems: groceryItems,
        budget: budget,
      );
    } catch (e) {
      throw Exception('Failed to fetch grocery list details: $e');
    }
  }

  /// Update a grocery item in a list
  Future<void> updateGroceryItem(
      String listId, String itemId, GroceryItemModel updatedItem) async {
    try {
      final groceryItemRef = _firestore
          .collection('groceryLists')
          .doc(listId)
          .collection('groceryItems')
          .doc(itemId);
      await groceryItemRef.update(updatedItem.toMap());
    } catch (e) {
      throw Exception('Failed to update grocery item: $e');
    }
  }

  /// Delete a grocery item from a list
  Future<void> deleteGroceryItem(String listId, String itemId) async {
    try {
      final groceryItemRef = _firestore
          .collection('groceryLists')
          .doc(listId)
          .collection('groceryItems')
          .doc(itemId);
      await groceryItemRef.delete();
    } catch (e) {
      throw Exception('Failed to delete grocery item: $e');
    }
  }

  /// Add a new grocery item to the list
  Future<void> addGroceryItem(String listId, GroceryItemModel newItem) async {
    try {
      final groceryItemsRef = _firestore
          .collection('groceryLists')
          .doc(listId)
          .collection('groceryItems');
      await groceryItemsRef.add(newItem.toMap());
    } catch (e) {
      throw Exception('Failed to add grocery item: $e');
    }
  }

  /// Delete a grocery list along with its subcollections (grocery items and budgets)
  Future<void> deleteGroceryList(String listId) async {
    try {
      final groceryListRef = _firestore.collection('groceryLists').doc(listId);

      // Delete grocery items subcollection
      final groceryItemsRef = groceryListRef.collection('groceryItems');
      final groceryItemsSnapshot = await groceryItemsRef.get();
      for (final doc in groceryItemsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete budget subcollection
      final budgetRef = groceryListRef.collection('budgets');
      final budgetSnapshot = await budgetRef.get();
      for (final doc in budgetSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the grocery list document
      await groceryListRef.delete();
    } catch (e) {
      throw Exception('Failed to delete grocery list: $e');
    }
  }

  /// Update the budget for a grocery list
  Future<void> updateBudget(String listId, double updatedAmount) async {
    try {
      final budgetRef = _firestore
          .collection('groceryLists')
          .doc(listId)
          .collection('budgets');
      final budgetSnapshot = await budgetRef.get();

      if (budgetSnapshot.docs.isNotEmpty) {
        // Update the existing budget document
        final budgetDocId = budgetSnapshot.docs.first.id;
        await budgetRef.doc(budgetDocId).update({'amount': updatedAmount});
      } else {
        // Create a new budget document if none exists
        await budgetRef.add({'amount': updatedAmount});
      }
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

    Future<void> updateGroceryListName(String listId, String newName) async {
    try {
      final groceryListRef = _firestore.collection('groceryLists').doc(listId);

      // Update the list name
      await groceryListRef.update({'name': newName});
    } catch (e) {
      throw Exception('Failed to update grocery list name: $e');
    }
  }
}

