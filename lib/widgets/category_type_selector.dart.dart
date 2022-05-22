import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryTypeSelector extends StatefulWidget {
  final ValueChanged<CategoryType>? onValueChanged;
  final CategoryType defaultValue;
  final String? dropdownHint;

  const CategoryTypeSelector({
    Key? key,
    this.defaultValue = CategoryType.expense,
    required this.dropdownHint,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<CategoryTypeSelector> createState() => _CategoryTypeSelectorState();
}

class _CategoryTypeSelectorState extends State<CategoryTypeSelector> {
  CategoryType? _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: DropdownButtonFormField<CategoryType>(
        elevation: 0,
        alignment: AlignmentDirectional.topCenter,
        decoration: const InputDecoration(border: InputBorder.none),
        icon: Icon(
          Icons.arrow_downward,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        items: const [
          DropdownMenuItem<CategoryType>(
            value: CategoryType.expense,
            child: Text(
              'Expense',
              style: TextStyle(fontSize: 16),
            ),
          ),
          DropdownMenuItem<CategoryType>(
            value: CategoryType.income,
            child: Text(
              'Income',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
        value: _value ?? widget.defaultValue,
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        onSaved: (value) {
          setState(() {
            _value = value;
          });
          widget.onValueChanged!(value!);
        },
        hint: Text(widget.dropdownHint!),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        iconEnabledColor: Colors.black,
        iconSize: 14,
      ),
    );
  }
}
