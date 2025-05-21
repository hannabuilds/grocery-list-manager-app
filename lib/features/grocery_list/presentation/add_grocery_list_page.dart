import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/entities/budget.dart';
import 'package:grocery_list_manager/features/budget_tracker/presentation/cubit/budget_tracker_cubit.dart';
import 'package:grocery_list_manager/features/grocery_item/domain/entities/grocery_item.dart';
import 'package:grocery_list_manager/features/grocery_item/presentation/cubit/grocery_item_cubit.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/entities/grocery_list.dart';
import 'package:grocery_list_manager/features/grocery_list/presentation/cubit/grocery_list_cubit.dart';

import '../../../core/services/injection_container.dart';

class AddGroceryListPage extends StatefulWidget {
  final GroceryList? groceryList;

  const AddGroceryListPage({super.key, this.groceryList});

  @override
  State<AddGroceryListPage> createState() => _AddGroceryListPageState();
}

class _AddGroceryListPageState extends State<AddGroceryListPage> {
  final TextEditingController _listNameController = TextEditingController();
  final List<Map<String, dynamic>> _groceryItems = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? _budgetAmount;

  late GroceryListCubit _groceryListCubit;
  late GroceryItemCubit _groceryItemCubit;
  late BudgetCubit _budgetCubit;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _groceryListCubit = serviceLocator<GroceryListCubit>();
    _groceryItemCubit = serviceLocator<GroceryItemCubit>();
    _budgetCubit = serviceLocator<BudgetCubit>();
  }

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }

  // Method to add a new grocery item
  void _addGroceryItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController itemNameController =
            TextEditingController();
        final TextEditingController itemQuantityController =
            TextEditingController();
        final TextEditingController itemPriceController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Add Grocery Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Item name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: itemQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity is required';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Enter a valid quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: itemPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                if (itemNameController.text.isEmpty ||
                    itemQuantityController.text.isEmpty ||
                    itemPriceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                setState(() {
                  _groceryItems.add({
                    'name': itemNameController.text,
                    'quantity': int.tryParse(itemQuantityController.text) ?? 1,
                    'price': double.tryParse(itemPriceController.text) ?? 0.0,
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to edit an existing grocery item
  void _editGroceryItem(int index) {
    final item = _groceryItems[index];
    final TextEditingController itemNameController =
        TextEditingController(text: item['name']);
    final TextEditingController itemQuantityController =
        TextEditingController(text: item['quantity'].toString());
    final TextEditingController itemPriceController =
        TextEditingController(text: item['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Grocery Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              TextFormField(
                controller: itemQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              TextFormField(
                controller: itemPriceController,
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _groceryItems[index] = {
                    'name': itemNameController.text,
                    'quantity': int.tryParse(itemQuantityController.text) ?? 1,
                    'price': double.tryParse(itemPriceController.text) ?? 0.0,
                  };
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // Method to set or edit the budget
  void _editBudget() {
    final TextEditingController budgetController =
        TextEditingController(text: _budgetAmount?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Budget'),
          content: TextFormField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Budget Amount',
              labelStyle: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _budgetAmount = double.tryParse(budgetController.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveGroceryList() async {
    if (_formKey.currentState!.validate()) {
      if (_groceryItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one item')),
        );
        return;
      }

      final listName = _listNameController.text;

      try {
        setState(() {
          _isLoading = true; // Set loading state to true
        });
        // Step 1: Create a new document reference in Firestore
        final groceryListDocRef =
            FirebaseFirestore.instance.collection('groceryLists').doc();

        // Step 2: Save the grocery list
        final groceryList = GroceryList(
          id: groceryListDocRef.id, // Use Firestore-generated ID
          name: listName,
          items: [],
        );
        await groceryListDocRef.set({
          'id': groceryList.id,
          'name': groceryList.name,
          'items': groceryList.items,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Step 3: Save the grocery items
        final itemsCollection = groceryListDocRef.collection('groceryItems');
        for (var item in _groceryItems) {
          final groceryItem = GroceryItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            listId: groceryList.id,
            name: item['name'],
            quantity: item['quantity'],
            price: item['price'],
          );

          await itemsCollection.doc(groceryItem.id).set({
            'id': groceryItem.id,
            'listId': groceryItem.listId,
            'name': groceryItem.name,
            'quantity': groceryItem.quantity,
            'price': groceryItem.price,
          });
        }

        // Step 4: Save the budget (if set)
        if (_budgetAmount != null) {
          final budget = Budget(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            listId: groceryList.id,
            amount: _budgetAmount!,
          );

          final budgetDocRef = groceryListDocRef.collection('budgets').doc();
          await budgetDocRef.set({
            'id': budget.id,
            'listId': budget.listId,
            'amount': budget.amount,
          });
        }

        // Step 5: Clear the form after saving
        setState(() {
          _listNameController.clear();
          _groceryItems.clear();
          _budgetAmount = null;
          _isLoading = false;
        });

        // Notify the user of success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grocery list saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Handle errors gracefully
        print("Error saving grocery list: $e");
        setState(() {
          _isLoading = false; // Set loading state to false on error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save grocery list. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.groceryList == null
        ? 'Add New Grocery List'
        : 'Edit ${widget.groceryList?.name}';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: const Color.fromARGB(147, 241, 187, 245),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Grocery List Name
                  TextFormField(
                    controller: _listNameController,
                    decoration: const InputDecoration(
                        labelText: 'Input Grocery List Name',
                        labelStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'List name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Add Item Button
                  ElevatedButton.icon(
                      onPressed: _addGroceryItem,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Add Grocery Item',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(146, 252, 211, 255))),
                  const SizedBox(height: 16.0),

                  // Display Budget if Set
                  if (_budgetAmount != null)
                    Text('Budget: ₱${_budgetAmount!.toStringAsFixed(2)}'),

                  const SizedBox(height: 16.0),
                  // List of Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: _groceryItems.length,
                      itemBuilder: (context, index) {
                        final item = _groceryItems[index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text(
                              'Quantity: ${item['quantity']} | Price: ₱${item['price'].toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editGroceryItem(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _groceryItems.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Budget Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: _editBudget,
                          icon: const Icon(
                            Icons.attach_money,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Set Budget',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(146, 252, 211, 255))),
                      const SizedBox(
                        width: 16.0,
                      ),
                      ElevatedButton.icon(
                          onPressed: _saveGroceryList,
                          icon: const Icon(
                            Icons.save,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Save',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(146, 252, 211, 255))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) // Show loading indicator if _isLoading is true
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
