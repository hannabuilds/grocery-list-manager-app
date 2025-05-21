import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/usecases/delete_budget.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/usecases/get_all_budget.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/usecases/set_budget.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/usecases/update_budget.dart';
import 'package:grocery_list_manager/features/grocery_item/domain/usecases/add_grocery_item.dart';
import 'package:grocery_list_manager/features/grocery_item/domain/usecases/delete_grocery_item.dart';
import 'package:grocery_list_manager/features/grocery_item/domain/usecases/get_all_grocery_items.dart';
import 'package:grocery_list_manager/features/grocery_item/domain/usecases/update_grocery_item.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/repos/grocery_list_repo.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/usecases/add_grocery_list.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/usecases/delete_grocery_list.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/usecases/get_all_grocery_lists.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/usecases/get_grocery_list_by_id.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/usecases/update_grocery_list.dart';
import 'package:grocery_list_manager/features/grocery_list/presentation/cubit/grocery_list_cubit.dart';

import '../../features/budget_tracker/data/data_source/budget_firebase_datasource.dart';
import '../../features/budget_tracker/data/data_source/budget_remote_datasource.dart';
import '../../features/budget_tracker/data/repository_impl/budget_repo_impl.dart';
import '../../features/budget_tracker/domain/repos/budget_repo.dart';
import '../../features/budget_tracker/domain/usecases/get_budget_by_list_id.dart';
import '../../features/budget_tracker/presentation/cubit/budget_tracker_cubit.dart';
import '../../features/grocery_item/data/data_source/grocery_item_firebase_datasource.dart';
import '../../features/grocery_item/data/data_source/grocery_item_remote_datasource.dart';
import '../../features/grocery_item/data/repository_impl/grocery_item_repo_impl.dart';
import '../../features/grocery_item/domain/repos/grocery_item_repo.dart';
import '../../features/grocery_item/domain/usecases/get_items_by_list_id.dart';
import '../../features/grocery_item/presentation/cubit/grocery_item_cubit.dart';
import '../../features/grocery_list/data/data_source/grocery_list_firebase_datasource.dart';
import '../../features/grocery_list/data/data_source/grocery_list_remote_datasource.dart';
import '../../features/grocery_list/data/repository_impl/grocery_list_repo_impl.dart';
import 'grocery_list_service.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //Feature 1: Grocery List
  //presentation layer
  serviceLocator.registerFactory(() => GroceryListCubit(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));

  //domain layer
  serviceLocator.registerLazySingleton(
      () => AddGroceryList(groceryListRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => DeleteGroceryList(groceryListRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAllGroceryLists(groceryListRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UpdateGroceryList(groceryListRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetGroceryListById(groceryListRepository: serviceLocator()));

//data layer
  serviceLocator.registerLazySingleton<GroceryListRepository>(
      () => GroceryListRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<GroceryListRemoteDatasource>(
      () => GroceryListFirebaseDatasource(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

//Feature 2: Grocery Item
  //presentation layer
  serviceLocator.registerFactory(() => GroceryItemCubit(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));

  //domain layer
  serviceLocator.registerLazySingleton(
      () => AddGroceryItem(groceryItemRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => DeleteGroceryItem(groceryItemRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetItemsByListId(groceryItemRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UpdateGroceryItem(groceryItemRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAllGroceryItems(groceryItemRepository: serviceLocator()));

//data layer
  serviceLocator.registerLazySingleton<GroceryItemRepository>(
      () => GroceryItemRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<GroceryItemRemoteDatasource>(
      () => GroceryItemFirebaseDatasource(serviceLocator()));

//Feature 3: Budget Tracker
  //presentation layer
  serviceLocator.registerFactory(() => BudgetCubit(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));

  //domain layer
  serviceLocator.registerLazySingleton(
      () => SetBudget(budgetRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => DeleteBudget(budgetRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetBudgetByListId(budgetRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UpdateBudget(budgetRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAllBudgets(budgetRepository: serviceLocator()));

//data layer
  serviceLocator.registerLazySingleton<BudgetRepository>(
      () => BudgetRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<BudgetRemoteDatasource>(
      () => BudgetFirebaseDatasource(serviceLocator()));


  // Register GroceryListService
  serviceLocator.registerLazySingleton<GroceryListService>(
    () => GroceryListService(firestore: serviceLocator<FirebaseFirestore>()),
  );
}
