import 'package:flutter/material.dart';
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
  GroceryItem? _lastRemovedItem;
  int? _lastRemovedItemIndex;

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

  void _removeItem(GroceryItem item) {
    setState(() {
      _lastRemovedItem = item;
      _lastRemovedItemIndex = _groceryItems.indexOf(item);
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        duration: const Duration(seconds: 2),
        content: Text(
          '${item.name} removed',
          style: (Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              )),
          textAlign: TextAlign.start,
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Theme.of(context).colorScheme.onErrorContainer,
          onPressed: _undoRemove,
        ),
      ),
    );
  }

  void _undoRemove() {
    if (_lastRemovedItem != null && _lastRemovedItemIndex != null) {
      setState(() {
        _groceryItems.insert(_lastRemovedItemIndex!, _lastRemovedItem!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _groceryItems.isEmpty
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
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  onPressed: _addItem,
                ),
                Text(
                  'No groceries yet!',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _groceryItems.length,
            itemBuilder: (ctx, index) => GroceryItemWidget(
                item: _groceryItems[index], onDismissed: _removeItem),
          );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Groceries',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
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
        body: content);
  }
}
