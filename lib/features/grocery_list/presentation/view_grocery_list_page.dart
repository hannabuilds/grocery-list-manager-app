import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_list_manager/core/services/grocery_list_service.dart';
import '../../../core/widgets/loading_state_shimmer_list.dart';
import '../../grocery_item/data/models/grocery_item_model.dart';
import 'cubit/grocery_list_cubit.dart';

class ViewGroceryListPage extends StatefulWidget {
  final String listId; // Pass only the listId

  const ViewGroceryListPage({super.key, required this.listId});

  @override
  State<ViewGroceryListPage> createState() => _ViewGroceryListPageState();
}

class _ViewGroceryListPageState extends State<ViewGroceryListPage> {
  late GroceryListService _groceryListService;
  late Future<GroceryListDetails> _groceryListDetailsFuture;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _groceryListService = GroceryListService(); // Initialize the service
    _groceryListDetailsFuture = _groceryListService.fetchGroceryListDetails(
        widget.listId); // Fetch the details for the list
    _nameController = TextEditingController();
  }

  Future<void> _updateGroceryListName(String updatedName) async {
    await _groceryListService.updateGroceryListName(widget.listId, updatedName);
    setState(() {
      _groceryListDetailsFuture =
          _groceryListService.fetchGroceryListDetails(widget.listId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grocery list name updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _addGroceryItem(GroceryItemModel newItem) async {
    await _groceryListService.addGroceryItem(widget.listId, newItem);
    setState(() {
      _groceryListDetailsFuture =
          _groceryListService.fetchGroceryListDetails(widget.listId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _deleteGroceryList() async {
    await _groceryListService.deleteGroceryList(widget.listId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grocery list successfully deleted!'),
          backgroundColor: Colors.green, // Optional: duration for the message
        ),
      );
    }
    Navigator.pop(context); // Navigate back after deleting the list
  }

  Future<void> _updateGroceryItem(
      String itemId, GroceryItemModel updatedItem) async {
    await _groceryListService.updateGroceryItem(
        widget.listId, itemId, updatedItem);
    setState(() {
      _groceryListDetailsFuture =
          _groceryListService.fetchGroceryListDetails(widget.listId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _deleteGroceryItem(String itemId) async {
    await _groceryListService.deleteGroceryItem(widget.listId, itemId);
    setState(() {
      _groceryListDetailsFuture =
          _groceryListService.fetchGroceryListDetails(widget.listId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item deleted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _updateBudget(double updatedAmount) async {
    await _groceryListService.updateBudget(widget.listId, updatedAmount);
    setState(() {
      _groceryListDetailsFuture =
          _groceryListService.fetchGroceryListDetails(widget.listId);
    });
    Navigator.pop(context, updatedAmount);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Budget updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(147, 241, 187, 245),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            context.read<GroceryListCubit>().fetchAllGroceryLists();
          },
        ),
        title: FutureBuilder<GroceryListDetails>(
          future: _groceryListDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController
                        ..text = snapshot.data!.groceryList.name,
                      onSubmitted: (newName) {
                        _updateGroceryListName(newName);
                      },
                      decoration: const InputDecoration(
                        hintText: "Edit List Name",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      _updateGroceryListName(_nameController.text);
                    },
                  ),
                ],
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Grocery List'),
                  content: const Text(
                      'Are you sure you want to delete this grocery list?',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                _deleteGroceryList();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<GroceryListDetails>(
        future: _groceryListDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingStateShimmerList();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final groceryListDetails = snapshot.data!;
            final budget = groceryListDetails.budget;
            final groceryItems = groceryListDetails.groceryItems;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the budget if available
                if (budget != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title:
                          Text('Budget: ₱${budget.amount.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditBudgetDialog(context, budget.amount);
                        },
                      ),
                    ),
                  ),
                // Display a message if no grocery items are found
                if (groceryItems.isEmpty)
                  const Center(child: Text('No items available.'))
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: groceryItems.length,
                      itemBuilder: (context, index) {
                        final item = groceryItems[index];
                        return ListTile(
                          title: Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'Quantity: ${item.quantity}\nPrice: ₱${item.price.toStringAsFixed(2)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditGroceryItemDialog(context, item);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Grocery List'),
                                      content: const Text(
                                        'Are you sure you want to delete this grocery item?',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Delete',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    _deleteGroceryItem(item.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddGroceryItemDialog(context);
        },
        label: const Text(
          'Add Item',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(147, 241, 187, 245),
      ),
    );
  }

  void _showAddGroceryItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Grocery Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                labelStyle: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                labelStyle: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              final newItem = GroceryItemModel(
                id: UniqueKey().toString(),
                name: nameController.text,
                quantity: int.parse(quantityController.text),
                price: double.parse(priceController.text),
                listId: widget.listId,
              );
              _addGroceryItem(newItem);
              Navigator.pop(context);
            },
            child: const Text('Add',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showEditGroceryItemDialog(BuildContext context, GroceryItemModel item) {
    final nameController = TextEditingController(text: item.name);
    final quantityController =
        TextEditingController(text: item.quantity.toString());
    final priceController =
        TextEditingController(text: item.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                labelStyle: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                labelStyle: TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              final updatedItem = GroceryItemModel(
                id: item.id,
                name: nameController.text,
                quantity: int.parse(quantityController.text),
                price: double.parse(priceController.text),
                listId: item.listId,
              );
              _updateGroceryItem(item.id, updatedItem);
              Navigator.pop(context);
            },
            child: const Text('Save',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, double currentAmount) {
    final budgetController =
        TextEditingController(text: currentAmount.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Budget'),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              labelText: 'Budget Amount',
              labelStyle: TextStyle(color: Colors.black, fontSize: 17)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              final updatedAmount = double.parse(budgetController.text);
              _updateBudget(updatedAmount);
              Navigator.pop(context);
              context.read<GroceryListCubit>().fetchAllGroceryLists();
            },
            child: const Text('Save',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
