import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({
    super.key,
    required this.item,
    required this.onDismissed,
  });

  final GroceryItem item;

  final Function(GroceryItem) onDismissed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          dismissThresholds: const {
            DismissDirection.endToStart: 0.5,
          },
          onDismissed: (direction) {
            onDismissed(item);
          },
          background: Container(
            color: Theme.of(context).colorScheme.errorContainer,
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete),
          ),
          child: ListTile(
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
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondaryFixed,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            trailing: Text(
              '${item.quantity}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
