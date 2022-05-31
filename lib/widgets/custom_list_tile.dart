import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/helpers.dart';
import '../widgets/snackbar.dart';

class CustomListTile extends StatelessWidget {
  final Map<String, dynamic>? iconCodeData;
  final String? title;
  final dynamic dataKey;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;
  final String? snackBarMessage;
  //data contains subtitle and trailing string
  //{'subtitle':...,'trailing':...}
  final Map<String, dynamic>? data;
  const CustomListTile({
    Key? key,
    this.iconCodeData,
    this.title,
    this.dataKey,
    this.onTap,
    this.onDismissed,
    this.snackBarMessage,
    this.data,
  }) : super(key: key);
  Widget showBackground(int direction) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red.withOpacity(0.2),
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Dismissible(
        key: ValueKey(dataKey),
        background: showBackground(0),
        secondaryBackground: showBackground(1),
        child: InkWell(
          key: ValueKey(dataKey),
          splashColor: Colors.grey,
          highlightColor: Colors.grey,
          onTap: onTap,
          child: Ink(
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                Helpers.retrieveIconFromCodeData(iconCodeData),
                color: Theme.of(context).primaryColor,
              ),
              title: Text(title!),
              subtitle: Text(
                data!['subtitle'],
                overflow: TextOverflow.clip,
                softWrap: true,
              ),
              trailing: Text(
                data!['trailing'],
                overflow: TextOverflow.clip,
                softWrap: true,
              ),
            ),
          ),
        ),
        onDismissed: (_) async {
          onDismissed!();
          showSnackbar(context, text: snackBarMessage);
        },
        confirmDismiss: (_) {
          return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.del_confirm1),
                content: Text(AppLocalizations.of(context)!.del_confirm2),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(AppLocalizations.of(context)!.no),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(AppLocalizations.of(context)!.yes),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
