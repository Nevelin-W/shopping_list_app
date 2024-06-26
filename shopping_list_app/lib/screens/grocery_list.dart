import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'dart:convert';
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
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  GroceryItem? _lastRemovedItem;
  int? _lastRemovedItemIndex;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-442c7-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error =
            'Failed to fetch data. Please try again later. ErrorCode:${response.statusCode}';
      });
      return;
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

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

  Future<void> _removeItem(GroceryItem item) async {
    setState(() {
      _lastRemovedItem = item;
      _lastRemovedItemIndex = _groceryItems.indexOf(item);
      _groceryItems.remove(item);
    });
    final url = Uri.https('flutter-prep-442c7-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (!mounted) return;

    if (mounted) {
      if (response.statusCode >= 400) {
        setState(() {
          _groceryItems.insert(_lastRemovedItemIndex!, _lastRemovedItem!);
        });
      }
    }
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).clearSnackBars();
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
  }

  void _undoRemove() {
    if (_lastRemovedItem != null && _lastRemovedItemIndex != null) {
      setState(() {
        _groceryItems.insert(_lastRemovedItemIndex!, _lastRemovedItem!);
      });
      final url = Uri.https('flutter-prep-442c7-default-rtdb.firebaseio.com',
          'shopping-list/${_lastRemovedItem!.id}.json');
      http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _lastRemovedItem!.name,
            'quantity': _lastRemovedItem!.quantity,
            'category': _lastRemovedItem!.category.title,
          },
        ),
      );
    }
  }

  void _onCheckedChanged(GroceryItem item, bool isChecked) {
    setState(() {
      item.isChecked = isChecked;
    });
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
              item: _groceryItems[index],
              onDismissed: _removeItem,
              onCheckedChanged: _onCheckedChanged,
            ),
          );

    if (_isLoading) {
      content = Center(
        heightFactor: 15,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          strokeAlign: 10,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (_error != null) {
      content = Center(
        heightFactor: 9,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Text(
            _error!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
      );
    }

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
