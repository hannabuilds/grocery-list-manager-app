import 'dart:convert';

import '../../domain/entities/grocery_list.dart';

class GroceryListModel extends GroceryList {
  const GroceryListModel({
    required super.id,
    required super.name,
    required super.items,
  });

  // Convert a Map to a GroceryListModel
  factory GroceryListModel.fromMap(Map<String, dynamic> map) {
    return GroceryListModel(
      id: map['id'],
      name: map['name'],
      items: List<String>.from(map['items']),
    );
  }

  // Convert JSON to a GroceryListModel
  factory GroceryListModel.fromJson(String source) {
    return GroceryListModel.fromMap(json.decode(source));
  }

  // Convert the GroceryListModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'items': items,
    };
  }

  // Convert the GroceryListModel to JSON
  String toJson() {
    return json.encode(toMap());
  }
}


