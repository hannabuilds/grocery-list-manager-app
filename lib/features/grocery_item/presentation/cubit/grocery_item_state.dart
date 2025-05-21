part of 'grocery_item_cubit.dart';


abstract class GroceryItemState extends Equatable {
  const GroceryItemState();
  
  @override
  List<Object> get props => [];
}

class GroceryItemInitial extends GroceryItemState {}


class GroceryItemLoading extends GroceryItemState {}


class GroceryItemLoaded extends GroceryItemState {
  final List<GroceryItem> groceryItems;
  
  const GroceryItemLoaded(this.groceryItems);
  
  @override
  List<Object> get props => [groceryItems];
}

class GroceryItemAdded extends GroceryItemState {}

class GroceryItemDeleted extends GroceryItemState {}

class GroceryItemUpdated extends GroceryItemState {
  final GroceryItem newGroceryItem;

  const GroceryItemUpdated(this.newGroceryItem);

  @override
  List<Object> get props => [newGroceryItem];
}

class GroceryItemError extends GroceryItemState {
  final String message;
  
  const GroceryItemError(this.message);
  
  @override
  List<Object> get props => [message];
}

