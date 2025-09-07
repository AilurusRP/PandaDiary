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
            overlayColor: MaterialStateProperty.all(Colors.grey[200])),
        onPressed: onPressed,
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        )));
  }
}
