import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  // declaring variables
  final String? buttonText;
  final Function? onPressed;
  final Function? onLongPress;

  const CalculatorButton({
    Key? key,
    this.buttonText,
    this.onLongPress,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onPressed!();
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(0.2),
        child: Text(
          buttonText!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
