import 'package:flutter/material.dart';

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
              child: const Text('Go back'),
            ),
        ],
      ),
    ),
  );
}
