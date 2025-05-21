import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list_manager/core/errors/exceptions.dart';
import 'package:grocery_list_manager/features/budget_tracker/data/data_source/budget_remote_datasource.dart';
import 'package:grocery_list_manager/features/budget_tracker/data/models/budget_model.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/entities/budget.dart';

class BudgetFirebaseDatasource implements BudgetRemoteDatasource {
  final FirebaseFirestore _firestore;

  BudgetFirebaseDatasource(this._firestore);

  @override
  Future<void> deleteBudget(String id) async {
    try {
      await _firestore.collection('budgets').doc(id).delete();
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
  Future<Budget> getBudgetByListId(String listId) async {
    try {
      final snapshot = await _firestore
          .collection('budgets')
          .where('listId', isEqualTo: listId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return Budget(
          id: snapshot.docs.first.id,
          amount: data['amount'],
          listId: data['listId'],
        );
      } else {
        throw Exception('No budget found for listId: $listId');
      }
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
  @override
Future<void> setBudget(Budget budget) async {
  try {
    // Ensure the budget's `listId` is correctly passed
    if (budget.listId.isEmpty) {
      throw const APIException(message: 'List ID is required for setting a budget.', statusCode: '400');
    }

    // Generate a unique ID for the budget document
    final budgetDocRef = _firestore.collection('budgets').doc();

    // Map the budget to a model
    final budgetModel = BudgetModel(
      id: budgetDocRef.id, 
      amount: budget.amount, 
      listId: budget.listId,
    );

    // Save the budget to Firestore
    await budgetDocRef.set(budgetModel.toMap());

    print('Budget set successfully for listId: ${budget.listId}');
  } on FirebaseException catch (e) {
    throw APIException(
      message: e.message ?? 'Failed to set budget in Firestore.',
      statusCode: e.code,
    );
  } catch (e) {
    throw APIException(message: e.toString(), statusCode: '500');
  }
}


  @override
  Future<void> updateBudget(Budget budget) async {
    final budgetModel = BudgetModel(
      id: budget.id,
      amount: budget.amount,
      listId: budget.listId,
    );

    try {
      await _firestore
          .collection('budgets')
          .doc(budget.id)
          .update(budgetModel.toMap());
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
  Future<List<Budget>> getAllBudgets() async {
    try {
      final querySnapshot = await _firestore.collection('budgets').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Budget(
          id: doc.id,
          amount: data['amount'],
          listId: data['listId'],
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
