import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/grocery_item.dart';
import '../../domain/usecases/add_grocery_item.dart';
import '../../domain/usecases/delete_grocery_item.dart';
import '../../domain/usecases/get_all_grocery_items.dart';
import '../../domain/usecases/get_items_by_list_id.dart';
import '../../domain/usecases/update_grocery_item.dart';

part 'grocery_item_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you are back online. ";

// GroceryItem Cubit
class GroceryItemCubit extends Cubit<GroceryItemState> {
  final AddGroceryItem addGroceryItemUseCase;
  final DeleteGroceryItem deleteGroceryItemUseCase;
  final GetItemsByListId getItemsByListIdUseCase;
  final UpdateGroceryItem updateGroceryItemUseCase;
  final GetAllGroceryItems getAllGroceryItemsUseCase;

  GroceryItemCubit(
    this.addGroceryItemUseCase,
    this.deleteGroceryItemUseCase,
    this.getItemsByListIdUseCase,
    this.updateGroceryItemUseCase,
    this.getAllGroceryItemsUseCase,
  ) : super(GroceryItemInitial());

  // Fetch grocery items by listId
  Future<void> fetchGroceryItemsByListId(String listId) async {
    emit(GroceryItemLoading());

    try {
      final result = await getItemsByListIdUseCase(listId).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryItemError(failure.getMessage())),
        (groceryItem) {
          emit(GroceryItemLoaded(groceryItem));
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryItemError(
          "There seems to be a problem with your internet connection"));
    }
  }

  // Add a new grocery item
  Future<void> addGroceryItem(GroceryItem groceryItem) async {
    emit(GroceryItemLoading());

    try {
      final result = await addGroceryItemUseCase(groceryItem).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryItemError(failure.getMessage())),
        (_) {
          emit(GroceryItemAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryItemError(noInternetErrorMessage));
    }
  }

  // Update an existing grocery item
  Future<void> updateGroceryItem(GroceryItem groceryItem) async {
    emit(GroceryItemLoading());

    try {
      final result = await updateGroceryItemUseCase(groceryItem).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryItemError(failure.getMessage())),
        (_) {
          emit(GroceryItemUpdated(groceryItem));
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryItemError(noInternetErrorMessage));
    }
  }

  // Delete a grocery item by id
  Future<void> deleteGroceryItem(String id) async {
    emit(GroceryItemLoading());

    try {
      final result = await deleteGroceryItemUseCase(id).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryItemError(failure.getMessage())),
        (_) {
          emit(GroceryItemDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryItemError(noInternetErrorMessage));
    }
  }


//fetch all grocery items
   Future<void> fetchAllGroceryItems() async {
    emit(GroceryItemLoading());

    try {
      final result = await getAllGroceryItemsUseCase().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryItemError(failure.getMessage())),
        (groceryItems) {
          emit(GroceryItemLoaded(groceryItems));
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryItemError("There seems to be a problem with your internet connection"));
    }
  }
}
