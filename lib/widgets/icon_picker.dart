import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/helpers.dart';

class IconPicker extends StatefulWidget {
  final Map<String, dynamic>? iconCodeData;
  final Function? onSelect;
  const IconPicker({
    Key? key,
    this.iconCodeData,
    this.onSelect,
  }) : super(key: key);

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  Map<String, dynamic>? _selectedIconCodeData;

  @override
  void initState() {
    _selectedIconCodeData = widget.iconCodeData;
    super.initState();
  }

  _pickIcon() async {
    IconData? iconData = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.cupertino],
      title: Text(AppLocalizations.of(context)!.pick_an_icon),
      closeChild: Text(AppLocalizations.of(context)!.close),
      searchHintText: AppLocalizations.of(context)!.search,
      noResultsText: AppLocalizations.of(context)!.no_results_for,
    );
    setState(() {
      if (iconData != null) {
        _selectedIconCodeData = Helpers.iconToCodeData(iconData);
      }
    });
    widget.onSelect!(_selectedIconCodeData);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _pickIcon,
          child: Text(AppLocalizations.of(context)!.icon_picker_select_icon),
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            Helpers.retrieveIconFromCodeData(_selectedIconCodeData),
            size: 60,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
