import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showSnackbar(context, {text, isPop}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 700),
      content: Row(
        children: [
          Text(text),
          if (isPop != null && isPop == true)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.snackbar_goback_button),
            ),
        ],
      ),
    ),
  );
}
