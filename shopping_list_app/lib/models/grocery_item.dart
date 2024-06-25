import 'package:shopping_list_app/models/category.dart';

class GroceryItem {
  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
  });
  final String id;
  final String name;
  final int quantity;
  final Category category;
  bool isChecked;
}
