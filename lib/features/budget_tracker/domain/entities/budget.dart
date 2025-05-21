import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final double amount;
  final String listId; 

  const Budget({
    required this.id,
    required this.amount,
    required this.listId,
  });
  
  @override
  List<Object> get props => [id];
}
