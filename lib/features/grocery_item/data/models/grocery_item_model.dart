import 'dart:convert';

import '../../domain/entities/grocery_item.dart';

class GroceryItemModel extends GroceryItem {
  const GroceryItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.price,
    required super.listId,
  });

  // Convert a Map to a GroceryItemModel
  factory GroceryItemModel.fromMap(Map<String, dynamic> map) {
    return GroceryItemModel(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      listId: map['listId'],
    );
  }

  // Convert JSON to a GroceryItemModel
  factory GroceryItemModel.fromJson(String source) {
    return GroceryItemModel.fromMap(json.decode(source));
  }

  // Convert the GroceryItemModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'listId': listId,
    };
  }

  // Convert the GroceryItemModel to JSON
  String toJson() {
    return json.encode(toMap());
  }
}
