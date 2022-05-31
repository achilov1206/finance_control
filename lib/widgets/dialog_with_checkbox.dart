import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogWithCheckbox extends StatefulWidget {
  final String title;
  final String checkboxText;
  final Function? beforeDelete;
  const DialogWithCheckbox({
    Key? key,
    required this.title,
    required this.checkboxText,
    this.beforeDelete,
  }) : super(key: key);

  @override
  State<DialogWithCheckbox> createState() => _DialogWithCheckboxState();
}

class _DialogWithCheckboxState extends State<DialogWithCheckbox> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        softWrap: true,
      ),
      content: Row(
        children: [
          Flexible(
            child: Text(
              widget.checkboxText,
              softWrap: true,
            ),
          ),
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor,
            ),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(AppLocalizations.of(context)!.no),
        ),
        TextButton(
          onPressed: () {
            if (_isChecked && widget.beforeDelete != null) {
              widget.beforeDelete!();
            }
            Navigator.pop(context, true);
          },
          child: Text(AppLocalizations.of(context)!.yes),
        ),
      ],
    );
  }
}
