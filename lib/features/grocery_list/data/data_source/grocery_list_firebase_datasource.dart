import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list_manager/core/errors/exceptions.dart';
import 'package:grocery_list_manager/features/grocery_list/data/data_source/grocery_list_remote_datasource.dart';
import 'package:grocery_list_manager/features/grocery_list/data/models/grocery_list_model.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/entities/grocery_list.dart';

class GroceryListFirebaseDatasource implements GroceryListRemoteDatasource {
  final FirebaseFirestore _firestore;

  GroceryListFirebaseDatasource(this._firestore);

  @override
  Future<String> addGroceryList(GroceryList groceryList) async {
    try {
      // Generate a new document reference with a unique ID
      final groceryListDocRef = _firestore.collection('groceryLists').doc();

      // Create a model with the generated ID
      final groceryListModel = GroceryListModel(
        id: groceryListDocRef.id,
        name: groceryList.name,
        items: groceryList.items,
      );

      // Save the document to Firestore
      await groceryListDocRef.set(groceryListModel.toMap());
      // Return the created document's ID
      return groceryListDocRef.id;
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? 'Unknown error has occurred',
        statusCode: e.code,
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteGroceryList(String id) async {
    try {
      await _firestore.collection('groceryLists').doc(id).delete();
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
  Future<List<GroceryList>> getAllGroceryLists() async {
    try {
      final querySnapshot = await _firestore.collection('groceryLists').get();
      return querySnapshot.docs.map((doc) {
        return GroceryList(
          id: doc.id,
          name: doc['name'],
          items: List<String>.from(doc['items']),
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
  Future<void> updateGroceryList(GroceryList groceryList) async {
    final groceryListModel = GroceryListModel(
        id: groceryList.id, name: groceryList.name, items: groceryList.items);

    try {
      await _firestore
          .collection('groceryLists')
          .doc(groceryList.id)
          .update(groceryListModel.toMap());
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
  Future<GroceryList> getGroceryListById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('groceryLists').doc(id).get();

      if (!docSnapshot.exists) {
        throw APIException(
            message: 'Grocery list with ID $id not found', statusCode: '404');
      }

      final data = docSnapshot.data()!;
      return GroceryList(
        id: docSnapshot.id,
        name: data['name'],
        items: List<String>.from(data['items'] ?? []),
      );
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
