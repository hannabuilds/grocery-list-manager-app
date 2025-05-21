import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_list_manager/core/services/grocery_list_service.dart';
import 'package:grocery_list_manager/core/services/injection_container.dart';
import 'package:grocery_list_manager/features/grocery_list/presentation/add_grocery_list_page.dart';
import 'package:grocery_list_manager/features/grocery_list/presentation/cubit/grocery_list_cubit.dart';

import '../../../core/widgets/empty_state_list.dart';
import '../../../core/widgets/error_state_list.dart';
import '../../../core/widgets/loading_state_shimmer_list.dart';
import '../../grocery_item/presentation/cubit/grocery_item_cubit.dart';
import 'view_grocery_list_page.dart';

class ViewAllGrocerylistPage extends StatefulWidget {
  const ViewAllGrocerylistPage({super.key});

  @override
  State<ViewAllGrocerylistPage> createState() => _ViewAllGrocerylistPage();
}

class _ViewAllGrocerylistPage extends State<ViewAllGrocerylistPage> {
  final GroceryListService _groceryListService = GroceryListService();
  final Map<String, String?> _budgets = {};

  @override
  void initState() {
    super.initState();
    context.read<GroceryListCubit>().fetchAllGroceryLists();
  }

  Future<void> _fetchBudgetForList(String listId) async {
    try {
      final groceryListDetails =
          await _groceryListService.fetchGroceryListDetails(listId);
      final budget = groceryListDetails.budget;

      setState(() {
        // Log the budget to ensure it’s properly fetched
        print("Fetched budget: $budget");

        _budgets[listId] = budget != null
            ? '₱${budget.amount.toStringAsFixed(2)}'
            : 'Budget not set';
      });
    } catch (e) {
      setState(() {
        _budgets[listId] = 'Error fetching budget';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        backgroundColor: const Color.fromARGB(147, 241, 187, 245),
      ),
      body: BlocBuilder<GroceryListCubit, GroceryListState>(
        builder: (context, state) {
          if (state is GroceryListLoading) {
            return const LoadingStateShimmerList();
          } else if (state is GroceryListLoaded) {
            if (state.groceryLists.isEmpty) {
              return const EmptyStateList(
                imageAssetname: 'assets/images/empty.webp',
                title: 'There are no grocery list yet.',
                description: 'Go to Add New List to create one.',
              );
            } else {
              return ListView.builder(
                itemCount: state.groceryLists.length,
                itemBuilder: (context, index) {
                  final currentGrocerylist = state.groceryLists[index];

                  if (!_budgets.containsKey(currentGrocerylist.id)) {
                    _fetchBudgetForList(currentGrocerylist.id);
                  }

                  final budget =
                      _budgets[currentGrocerylist.id] ?? 'Loading...';

                  return Card(
                    child: ListTile(
                      title: Text(
                        currentGrocerylist.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text('Budget: $budget'),
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value:
                                    BlocProvider.of<GroceryItemCubit>(context),
                                child: ViewGroceryListPage(
                                    listId: currentGrocerylist.id,
                                    ),
                              ),
                            ));
                        if (result is double) {
                          setState(() {
                            _budgets[currentGrocerylist.id] =
                                '₱${result.toStringAsFixed(2)}';
                          });
                        }
                        context.read<GroceryListCubit>().fetchAllGroceryLists();
                        if (result.runtimeType == String) {
                          final snackBar = SnackBar(content: Text(result));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  );
                },
              );
            }
          } else if (state is GroceryListError) {
            return ErrorStateList(
              imageAssetname: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<GroceryListCubit>().fetchAllGroceryLists();
              },
            );
          } else {
            return const EmptyStateList(
              imageAssetname: 'assets/images/empty.webp',
              title: 'There are no grocery list yet.',
              description: 'Go to Add New List to create one.',
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => serviceLocator<GroceryListCubit>(),
                  child: const AddGroceryListPage(),
                ),
              ));

          context.read<GroceryListCubit>().fetchAllGroceryLists();

          if (result.runtimeType == String) {
            final snackBar = SnackBar(content: Text(result));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        backgroundColor: const Color.fromARGB(149, 234, 147, 241),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
