import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_list_manager/core/services/injection_container.dart';
import 'package:grocery_list_manager/features/grocery_list/presentation/cubit/grocery_list_cubit.dart';
import 'core/widgets/about_page.dart';
import 'features/budget_tracker/presentation/cubit/budget_tracker_cubit.dart';
import 'features/grocery_item/presentation/cubit/grocery_item_cubit.dart';
import 'features/grocery_list/presentation/add_grocery_list_page.dart';
import 'features/grocery_list/presentation/view_all_groceryList_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<GroceryListCubit>()),
        BlocProvider(create: (_) => serviceLocator<GroceryItemCubit>()),
        BlocProvider(create: (_) => serviceLocator<BudgetCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (context) => serviceLocator<GroceryListCubit>(),
            child: const ViewAllGrocerylistPage(),
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => serviceLocator<GroceryListCubit>()),
              BlocProvider(create: (_) => serviceLocator<GroceryItemCubit>()),
              BlocProvider(create: (_) => serviceLocator<BudgetCubit>()),
            ],
            child: const AddGroceryListPage(),
          ),
          const Center(
            child: AboutPage(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            try {
              // Fetch the updated grocery lists (returns void)
              await context.read<GroceryListCubit>().fetchAllGroceryLists();
            } catch (e) {
              // Handle any errors that occur during the refresh
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to refresh grocery lists: $e')),
              );
            }
          } else {
            // Handle other navigation options
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store_rounded),
            label: 'Grocery List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_add),
            label: 'Add New List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_support_rounded),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
