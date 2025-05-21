import 'package:equatable/equatable.dart';

class GroceryList extends Equatable {
  final String id;
  final String name;
  final List<String> items; 
  
  const GroceryList({
    required this.id,
    required this.name,
    required this.items,
  });
  
  @override
  List<Object> get props => [id];
}

