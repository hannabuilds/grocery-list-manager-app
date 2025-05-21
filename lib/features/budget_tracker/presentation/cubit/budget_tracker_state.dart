part of 'budget_tracker_cubit.dart';


// Base State
abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

// Initial State
class BudgetInitial extends BudgetState {}

// Loading State
class BudgetLoading extends BudgetState {}

// Loaded State
class BudgetLoaded extends BudgetState {
  final List<Budget> budgets;

  const BudgetLoaded(this.budgets);

  @override
  List<Object> get props => [budgets];
}

class BudgetByIdLoaded extends BudgetState {
  final Budget budget;

  const BudgetByIdLoaded(this.budget);

  @override
  List<Object> get props => [budget];
}

class BudgetAdded extends BudgetState {}

class BudgetDeleted extends BudgetState {}

class BudgetUpdated extends BudgetState {
  final Budget newBudget;

  const BudgetUpdated(this.newBudget);

  @override
  List<Object> get props => [newBudget];
}

// Error State
class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object> get props => [message];
}



