import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

class CurrencyPicker extends StatefulWidget {
  final Function onCurrencySelected;
  final String? currencySymbol;
  const CurrencyPicker({
    Key? key,
    required this.onCurrencySelected,
    this.currencySymbol,
  }) : super(key: key);

  @override
  State<CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  String? _currency;

  @override
  void initState() {
    _currency = widget.currencySymbol ?? 'UZS';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.grey,
        ),
      ),
      onPressed: () {
        showCurrencyPicker(
          context: context,
          showFlag: true,
          showSearchField: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (Currency currency) {
            setState(() {
              _currency = currency.code;
            });
            widget.onCurrencySelected(_currency);
          },
          favorite: ['UZS', 'USD'],
        );
      },
      child: Text(_currency!),
    );
  }
}
