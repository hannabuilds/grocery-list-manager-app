part of 'grocery_list_cubit.dart';

abstract class GroceryListState extends Equatable {
  const GroceryListState();

  @override
  List<Object> get props => [];
}

class GroceryListInitial extends GroceryListState {}

class GroceryListLoading extends GroceryListState {}

class GroceryListLoaded extends GroceryListState {
  final List<GroceryList> groceryLists;

  const GroceryListLoaded(this.groceryLists);

  @override
  List<Object> get props => [groceryLists];
}

class GroceryListByIdLoaded extends GroceryListState {
  final GroceryList groceryList;

  const GroceryListByIdLoaded(this.groceryList);

  @override
  List<Object> get props => [groceryList];
}


class GroceryListAdded extends GroceryListState {}

class GroceryListDeleted extends GroceryListState {}

class GroceryListUpdated extends GroceryListState {
  final GroceryList newGroceryList;

  const GroceryListUpdated(this.newGroceryList);

  @override
  List<Object> get props => [newGroceryList];
}


class GroceryListError extends GroceryListState {
  final String message;

  const GroceryListError(this.message);

  @override
  List<Object> get props => [message];
}
