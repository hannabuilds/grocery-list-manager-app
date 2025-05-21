import 'package:equatable/equatable.dart';

class GroceryItem extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String listId; 

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.listId,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? listId,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      listId: listId ?? this.listId,
    );
  }
  
  @override
  List<Object> get props => [id];
}

