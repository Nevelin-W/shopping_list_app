import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({
    super.key,
  });

  @override
  State<NewItemScreen> createState() {
    return _NewItemScreenState();
  }
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateAppBarTitle);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateAppBarTitle() {
    setState(() {});
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(
            id: DateTime.now().toString(),
            name: _enteredName,
            quantity: _enteredQuantity,
            category: _selectedCategory),
      );
    }
  }

  String? _validateQuantity(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.trim().isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value)! <= 0) {
      return 'Invalid quantity.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Add ${_nameController.text.isEmpty ? '' : _nameController.text}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  )),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().isEmpty ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            helperText: ' ',
                            label: Text('Quantity'),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: '1',
                          validator: _validateQuantity,
                          onSaved: (value) {
                            _enteredQuantity = int.parse(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 180,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            helperText: ' ',
                            label: Text('Category'),
                          ),
                          value: _selectedCategory,
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(category.value.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                  ],
                                ),
                              )
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Reset'),
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                      ),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: const Text('Add'),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
