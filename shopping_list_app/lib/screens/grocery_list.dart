import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/widgets/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({
    super.key,
  });

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Groceries',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            iconSize: 30,
            onPressed: _addItem,
          ),
        ],
      ),
      body: _groceryItems.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_shopping_cart_outlined,
                    size: 100,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: _addItem,
                ),
                Text(
                  'No groceries yet!',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                ),
                const SizedBox(height: 150),
              ],
            ))
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) =>
                  GroceryItemWidget(item: _groceryItems[index]),
            ),

      /*  body: ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) =>
            GroceryItemWidget(item: _groceryItems[index]),
      ), */
    );
  }
}
