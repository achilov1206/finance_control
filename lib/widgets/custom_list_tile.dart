import 'package:finance2/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import '../utils/helpers.dart';

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
                title: const Text('Are you sure?'),
                content: const Text('Do yot really want to delete?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
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
