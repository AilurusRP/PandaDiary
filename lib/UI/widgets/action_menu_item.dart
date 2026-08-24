import 'package:flutter/material.dart';

class ActionMenuItem extends StatelessWidget {
  const ActionMenuItem({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            overlayColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.secondary.withValues(alpha: .2))),
        onPressed: onPressed,
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        )));
  }
}
