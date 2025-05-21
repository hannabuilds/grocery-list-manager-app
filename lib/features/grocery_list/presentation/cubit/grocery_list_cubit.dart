import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/grocery_list.dart';
import '../../domain/usecases/add_grocery_list.dart';
import '../../domain/usecases/delete_grocery_list.dart';
import '../../domain/usecases/get_all_grocery_lists.dart';
import '../../domain/usecases/get_grocery_list_by_id.dart';
import '../../domain/usecases/update_grocery_list.dart';

part 'grocery_list_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you are back online. ";

// GroceryList State Management using Cubit
class GroceryListCubit extends Cubit<GroceryListState> {
  final AddGroceryList addGroceryListUseCase;
  final DeleteGroceryList deleteGroceryListUseCase;
  final GetAllGroceryLists getAllGroceryListsUseCase;
  final GetGroceryListById getGroceryListByIdUseCase;
  final UpdateGroceryList updateGroceryListUseCase;

  GroceryListCubit(
    this.addGroceryListUseCase,
    this.deleteGroceryListUseCase,
    this.getAllGroceryListsUseCase,
    this.getGroceryListByIdUseCase,
    this.updateGroceryListUseCase,
  ) : super(GroceryListInitial());

  // Fetch all grocery lists
  Future<void> fetchAllGroceryLists() async {
    emit(GroceryListLoading());

    try {
      final result = await getAllGroceryListsUseCase().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryListError(failure.getMessage())),
        (groceryLists) {
          emit(GroceryListLoaded(groceryLists));
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryListError(
          "There seems to be a problem with your internet connection"));
    }
  }

// Fetch a grocery list by ID
  Future<void> fetchGroceryListById(String id) async {
    emit(GroceryListLoading());

    try {
      final result = await getGroceryListByIdUseCase(id).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryListError(failure.getMessage())),
        (groceryList) {
          emit(GroceryListByIdLoaded(groceryList));
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryListError(
          "There seems to be a problem with your internet connection"));
    }
  }

  // Add new grocery list
  Future<void> addGroceryList(GroceryList groceryList) async {
    emit(GroceryListLoading());

    try {
      final result = await addGroceryListUseCase(groceryList).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryListError(failure.getMessage())),
        (_) {
          emit(GroceryListAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryListError(noInternetErrorMessage));
    }
  }

  // Update existing grocery list
  Future<void> updateGroceryList(GroceryList groceryList) async {
    emit(GroceryListLoading());

    try {
      final result = await updateGroceryListUseCase(groceryList).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryListError(failure.getMessage())),
        (_) {
          emit(GroceryListUpdated(groceryList));
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryListError(noInternetErrorMessage));
    }
  }

  // Delete a grocery list by id
  Future<void> deleteGroceryList(String id) async {
    emit(GroceryListLoading());

    try {
      final result = await deleteGroceryListUseCase(id).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(GroceryListError(failure.getMessage())),
        (_) {
          emit(GroceryListDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(const GroceryListError(noInternetErrorMessage));
    }
  }
}
