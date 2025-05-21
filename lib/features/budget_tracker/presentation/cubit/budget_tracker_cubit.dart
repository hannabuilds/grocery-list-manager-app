import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/entities/budget.dart';

import '../../domain/usecases/delete_budget.dart';
import '../../domain/usecases/get_all_budget.dart';
import '../../domain/usecases/get_budget_by_list_id.dart';
import '../../domain/usecases/set_budget.dart';
import '../../domain/usecases/update_budget.dart';

part 'budget_tracker_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you are back online. ";

// Budget Cubit
class BudgetCubit extends Cubit<BudgetState> {
  final SetBudget addBudgetUseCase;
  final DeleteBudget deleteBudgetUseCase;
  final GetBudgetByListId getBudgetByListIdUseCase;
  final UpdateBudget updateBudgetUseCase;
  final GetAllBudgets getAllBudgetsUseCase;

  BudgetCubit(
    this.addBudgetUseCase,
    this.deleteBudgetUseCase,
    this.getBudgetByListIdUseCase,
    this.updateBudgetUseCase,
    this.getAllBudgetsUseCase,
  ) : super(BudgetInitial());

  // Get all budgets
  Future<void> fetchAllBudgets() async {
    emit(BudgetLoading());

    try {
      final result = await getAllBudgetsUseCase().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(BudgetError(failure.getMessage())),
        (budgets) {
          emit(BudgetLoaded(budgets));
        },
      );
    } on TimeoutException catch (_) {
      emit(const BudgetError(
          "There seems to be a problem with your internet connection"));
    }
  }

  // Get all budgets by listId
  Future<void> fetchBudgetsByListId(String listId) async {
    emit(BudgetLoading());

    try {
      final result = await getBudgetByListIdUseCase(listId).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(BudgetError(failure.getMessage())),
        (budget) {
          emit(BudgetByIdLoaded(budget));
        },
      );
    } on TimeoutException catch (_) {
      emit(const BudgetError(
          "There seems to be a problem with your internet connection"));
    }
  }

  // Add new budget
  Future<void> addBudget(Budget budget) async {
    emit(BudgetLoading());

    try {
      final result = await addBudgetUseCase(budget).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(BudgetError(failure.getMessage())),
        (_) {
          emit(BudgetAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(const BudgetError(noInternetErrorMessage));
    }
  }

  // Update an existing budget
  Future<void> updateBudget(Budget budget) async {
    emit(BudgetLoading());

    try {
      final result = await updateBudgetUseCase(budget).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(BudgetError(failure.getMessage())),
        (_) {
          emit(BudgetUpdated(budget));
        },
      );
    } on TimeoutException catch (_) {
      emit(const BudgetError(noInternetErrorMessage));
    }
  }

  // Delete a budget by id
  Future<void> deleteBudget(String id) async {
    emit(BudgetLoading());

    try {
      final result = await deleteBudgetUseCase(id).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request time out"));
      result.fold(
        (failure) => emit(BudgetError(failure.getMessage())),
        (_) {
          emit(BudgetDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(const BudgetError(noInternetErrorMessage));
    }
  }
}
