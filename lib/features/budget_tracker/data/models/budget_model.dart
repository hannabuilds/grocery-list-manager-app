import 'dart:convert';

import '../../domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.amount,
    required super.listId,
  });

  // Convert a Map to a BudgetModel
  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      amount: map['amount'],
      listId: map['listId'],
    );
  }

  // Convert JSON to a BudgetModel
  factory BudgetModel.fromJson(String source) {
    return BudgetModel.fromMap(json.decode(source));
  }

  // Convert the BudgetModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'listId': listId,
    };
  }

  // Convert the BudgetModel to JSON
  String toJson() {
    return json.encode(toMap());
  }
}
