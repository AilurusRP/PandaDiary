import 'package:flutter/material.dart';

class ActionMenuItem extends StatefulWidget {
  const ActionMenuItem({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  State<ActionMenuItem> createState() => _ActionMenuItemState();
}

class _ActionMenuItemState extends State<ActionMenuItem> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.grey[200])),
        onPressed: widget.onPressed,
        child: Center(
            child: Text(
          widget.text,
          style: const TextStyle(color: Colors.black),
        )));
  }
}
