import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({
    super.key,
    required this.item,
  });

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 17),
          leading: Container(
            width: 25,
            height: 25,
            color: item.category.color,
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          trailing: Text(
            '${item.quantity}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
