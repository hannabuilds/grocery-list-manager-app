// models.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryListDetails {
  final String id;
  final String name;
  final Timestamp createdAt;
  final List<GroceryItem> items;
  final Budget? budget;

  GroceryListDetails({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.items,
    this.budget,
  });
}

class GroceryItem {
  final String id;
  final String listId;
  final String name;
  final int quantity;
  final double price;

  GroceryItem({
    required this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class Budget {
  final String id;
  final String listId;
  final double amount;

  Budget({
    required this.id,
    required this.listId,
    required this.amount,
  });
}
