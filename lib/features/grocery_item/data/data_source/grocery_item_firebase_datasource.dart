import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list_manager/core/errors/exceptions.dart';
import 'package:grocery_list_manager/features/grocery_item/data/data_source/grocery_item_remote_datasource.dart';
import 'package:grocery_list_manager/features/grocery_item/data/models/grocery_item_model.dart';
import 'package:grocery_list_manager/features/grocery_item/domain/entities/grocery_item.dart';

class GroceryItemFirebaseDatasource
    implements GroceryItemRemoteDatasource {
  final FirebaseFirestore _firestore;

  GroceryItemFirebaseDatasource(this._firestore);

  @override
 Future<void> addItem(GroceryItem groceryItem) async {
  try {
    // Ensure the grocery item's `listId` is correctly passed
    if (groceryItem.listId.isEmpty) {
      throw const APIException(message: 'List ID is required for adding a grocery item.', statusCode: '400');
    }

    // Generate a unique ID for the grocery item document
    final groceryItemDocRef = _firestore.collection('groceryItems').doc();

    // Map the grocery item to a model
    final groceryItemModel = GroceryItemModel(
      id: groceryItemDocRef.id,
      name: groceryItem.name,
      quantity: groceryItem.quantity,
      price: groceryItem.price,
      listId: groceryItem.listId,
    );

    // Save the grocery item to Firestore
    await groceryItemDocRef.set(groceryItemModel.toMap());

    print('Grocery item added successfully for listId: ${groceryItem.listId}');
  } on FirebaseException catch (e) {
    throw APIException(
      message: e.message ?? 'Failed to add grocery item in Firestore.',
      statusCode: e.code,
    );
  } catch (e) {
    throw APIException(message: e.toString(), statusCode: '500');
  }
}


  @override
  Future<void> deleteItem(String id) async {
    try {
      await _firestore.collection('groceryItems').doc(id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<GroceryItem>> getItemsByListId(String listId) async {
    try {
      final querySnapshot = await _firestore
          .collection('groceryItems')
          .where('listId', isEqualTo: listId)
          .get();

      return querySnapshot.docs.map((doc) {
        return GroceryItem(
          id: doc.id,
          name: doc.data()['name'],
          quantity: doc.data()['quantity'],
          price: doc.data()['price'],
          listId: doc.data()['listId'],
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateItem(GroceryItem groceryItem) async {
    final groceryItemModel = GroceryItemModel(
        id: groceryItem.id,
        name: groceryItem.name,
        quantity: groceryItem.quantity,
        price: groceryItem.price,
        listId: groceryItem.listId);

    try {
      await _firestore.collection('groceryItems').doc(groceryItem.id).update(groceryItemModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
  
  @override
   Future<List<GroceryItem>> getAllItems() async {
    try {
      final querySnapshot = await _firestore.collection('groceryItems').get();

      return querySnapshot.docs.map((doc) {
        return GroceryItem(
          id: doc.id,
          name: doc.data()['name'],
          quantity: doc.data()['quantity'],
          price: doc.data()['price'],
          listId: doc.data()['listId'],
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
