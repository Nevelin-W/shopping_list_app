import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryItemWidget extends StatefulWidget {
  const GroceryItemWidget({
    super.key,
    required this.item,
    required this.onDismissed,
    required this.onCheckedChanged,
  });

  final GroceryItem item;

  final Function(GroceryItem) onDismissed;
  final Function(GroceryItem, bool) onCheckedChanged;

  @override
  State<GroceryItemWidget> createState() => _GroceryItemWidgetState();
}

class _GroceryItemWidgetState extends State<GroceryItemWidget> {
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
            widget.onDismissed(widget.item);
          },
          background: Container(
            color: Theme.of(context).colorScheme.errorContainer,
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete),
          ),
          child: Opacity(
            opacity: widget.item.isChecked ? 0.35 : 1.0,
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 17),
              leading: Container(
                width: 25,
                height: 25,
                color: widget.item.category.color,
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondaryFixed,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '${widget.item.quantity}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        shape: const CircleBorder(),
                        activeColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        value: widget.item.isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.item.isChecked = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              tileColor: widget.item.isChecked
                  ? Theme.of(context).colorScheme.onInverseSurface
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
